package main

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

type TerraformTester interface {
	ConfigureOptions(t *testing.T) *terraform.Options
	Deploy(t *testing.T, opts *terraform.Options)
	Cleanup(t *testing.T, opts *terraform.Options)
}

type StandardTerraformModule struct {
	Name string
	Path string
}

func NewStandardTerraformModule(name, path string) *StandardTerraformModule {
	return &StandardTerraformModule{
		Name: name,
		Path: path,
	}
}

func (m *StandardTerraformModule) ConfigureOptions(t *testing.T) *terraform.Options {
	return &terraform.Options{
		TerraformDir: m.Path,
		NoColor:      true,
		Parallelism:  20,
	}
}

func (m *StandardTerraformModule) Deploy(t *testing.T, opts *terraform.Options) {
	terraform.WithDefaultRetryableErrors(t, &terraform.Options{})
	terraform.InitAndApply(t, opts)
}

func (m *StandardTerraformModule) Cleanup(t *testing.T, opts *terraform.Options) {
	terraform.Destroy(t, opts)
	cleanupFiles(t, opts.TerraformDir)
}

func cleanupFiles(t *testing.T, dir string) {
	filesToCleanup := []string{"*.terraform*", "*tfstate*"}
	for _, pattern := range filesToCleanup {
		matches, err := filepath.Glob(filepath.Join(dir, pattern))
		if err != nil {
			t.Logf("Error globbing %s: %v", pattern, err)
			continue
		}
		for _, filePath := range matches {
			if err := os.RemoveAll(filePath); err != nil {
				t.Logf("Failed to remove %s: %v", filePath, err)
			}
		}
	}
}

func TestApplyNoError(t *testing.T) {
	t.Parallel()
	tfPath := os.Getenv("TF_PATH")
	if tfPath == "" {
		t.Fatal("TF_PATH environment variable is not set")
	}
	modulePath := filepath.Join("..", "examples", tfPath)
	module := NewStandardTerraformModule(tfPath, modulePath)

	t.Run(module.Name, func(t *testing.T) {
		opts := module.ConfigureOptions(t)
		defer module.Cleanup(t, opts)
		module.Deploy(t, opts)
	})
}
