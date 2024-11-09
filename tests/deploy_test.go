package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var (
	skipDestroy   bool
	exception     string
	example       string
	exceptionList map[string]bool
)

func init() {
	flag.BoolVar(&skipDestroy, "skip-destroy", false, "Skip running terraform destroy after apply")
	flag.StringVar(&exception, "exception", "", "Comma-separated list of examples to exclude")
	flag.StringVar(&example, "example", "", "Specific example to test")
}

func parseExceptionList() {
	exceptionList = make(map[string]bool)
	if exception != "" {
		examples := strings.Split(exception, ",")
		for _, ex := range examples {
			exceptionList[strings.TrimSpace(ex)] = true
		}
	}
}

type Module struct {
	Name    string
	Path    string
	Options *terraform.Options
}

type ModuleManager struct {
	BaseExamplesPath string
}

func NewModuleManager(baseExamplesPath string) *ModuleManager {
	return &ModuleManager{
		BaseExamplesPath: baseExamplesPath,
	}
}

func NewModule(name, path string) *Module {
	return &Module{
		Name: name,
		Path: path,
		Options: &terraform.Options{
			TerraformDir: path,
			NoColor:      true,
		},
	}
}

func (mm *ModuleManager) DiscoverModules() ([]*Module, error) {
	var modules []*Module

	entries, err := os.ReadDir(mm.BaseExamplesPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read examples directory: %v", err)
	}

	for _, entry := range entries {
		if entry.IsDir() {
			moduleName := entry.Name()
			if exceptionList[moduleName] {
				fmt.Printf("Skipping module %s as it is in the exception list\n", moduleName)
				continue
			}
			modulePath := filepath.Join(mm.BaseExamplesPath, moduleName)
			modules = append(modules, NewModule(moduleName, modulePath))
		}
	}

	return modules, nil
}

func (m *Module) Apply(t *testing.T) error {
	t.Helper()
	t.Logf("Applying Terraform module: %s", m.Name)
	terraform.WithDefaultRetryableErrors(t, m.Options)
	_, err := terraform.InitAndApplyE(t, m.Options)
	return err
}

func (m *Module) Destroy(t *testing.T) error {
	t.Helper()
	t.Logf("Destroying Terraform module: %s", m.Name)
	_, err := terraform.DestroyE(t, m.Options)
	if err != nil {
		return fmt.Errorf("destroy failed: %v", err)
	}
	if err := m.cleanupFiles(t); err != nil {
		return fmt.Errorf("cleanup failed: %v", err)
	}
	return nil
}

func (m *Module) cleanupFiles(t *testing.T) error {
	t.Helper()
	t.Logf("Cleaning up in: %s", m.Options.TerraformDir)
	filesToCleanup := []string{"*.terraform*", "*tfstate*", "*.lock.hcl"}

	for _, pattern := range filesToCleanup {
		matches, err := filepath.Glob(filepath.Join(m.Options.TerraformDir, pattern))
		if err != nil {
			return fmt.Errorf("error matching pattern %s: %v", pattern, err)
		}
		for _, filePath := range matches {
			if err := os.RemoveAll(filePath); err != nil {
				return fmt.Errorf("failed to remove %s: %v", filePath, err)
			}
		}
	}
	return nil
}

func RunTests(t *testing.T, modules []*Module, parallel bool) {
	for _, module := range modules {
		module := module
		t.Run(module.Name, func(t *testing.T) {
			if parallel {
				t.Parallel()
			}
			if !skipDestroy {
				defer func() {
					if err := module.Destroy(t); err != nil {
						t.Logf("Warning: Cleanup for module %s failed: %v", module.Name, err)
					}
				}()
			}
			if err := module.Apply(t); err != nil {
				t.Fatalf("Failed to apply module %s: %v", module.Name, err)
			}
		})
	}
}

func TestApplyNoError(t *testing.T) {
	flag.Parse()
	parseExceptionList()

	if example == "" {
		t.Fatal("-example flag is not set")
	}

	if exceptionList[example] {
		t.Skipf("Skipping example %s as it is in the exception list", example)
	}

	modulePath := filepath.Join("..", "examples", example)
	module := NewModule(example, modulePath)

	if !skipDestroy {
		defer func() {
			if err := module.Destroy(t); err != nil {
				t.Logf("Warning: Cleanup failed: %v", err)
			}
		}()
	}

	if err := module.Apply(t); err != nil {
		t.Fatalf("Failed to apply module: %v", err)
	}
}

func TestApplyAllSequential(t *testing.T) {
	flag.Parse()
	parseExceptionList()

	manager := NewModuleManager(filepath.Join("..", "examples"))
	modules, err := manager.DiscoverModules()
	if err != nil {
		t.Fatalf("Failed to discover modules: %v", err)
	}

	RunTests(t, modules, false)
}

func TestApplyAllParallel(t *testing.T) {
	flag.Parse()
	parseExceptionList()

	manager := NewModuleManager(filepath.Join("..", "examples"))
	modules, err := manager.DiscoverModules()
	if err != nil {
		t.Fatalf("Failed to discover modules: %v", err)
	}

	RunTests(t, modules, true)
}
