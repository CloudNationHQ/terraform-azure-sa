package main

import (
	"context"
	"fmt"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/cloudnationhq/terraform-azure-sa/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type StorageFetcher interface {
	FetchResourceDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error)
}

type StorageVerifier interface {
	Verify(t *testing.T, details []ResourceDetail, expectedOutputs map[string]string)
}

type ClientInitializer interface {
	InitClients(subscriptionID string) (*AzureClients, error)
}

type AzureClients struct {
	SubscriptionID  string
	Cred            *azidentity.DefaultAzureCredential
	ContainerClient *armstorage.BlobContainersClient
	ShareClient     *armstorage.FileSharesClient
	QueueClient     *armstorage.QueueClient
}

type TestConfig struct {
	subscriptionID    string
	resourceGroupName string
	accountName       string
	tfOpts            *terraform.Options
}

type ResourceDetail struct {
	Name              string
	ResourceGroupName string
	ProvisioningState string
}

type AzureStorageFetcher struct{}

type StorageSubResourceVerifier struct{}

type StorageResourceVerifier struct{}

type AzureClientInitializer struct{}

func (a *AzureClientInitializer) InitClients(subscriptionID string) (*AzureClients, error) {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create credentials: %w", err)
	}

	clients := &AzureClients{
		SubscriptionID: subscriptionID,
		Cred:           cred,
	}

	clientInitFuncs := map[string]func(*AzureClients) error{
		"ContainerClient": a.initContainerClient,
		"ShareClient":     a.initShareClient,
		"QueueClient":     a.initQueueClient,
	}

	for clientName, initFunc := range clientInitFuncs {
		if err := initFunc(clients); err != nil {
			return nil, fmt.Errorf("failed to initialize %s: %w", clientName, err)
		}
	}

	return clients, nil
}

func (a *AzureClientInitializer) initContainerClient(clients *AzureClients) error {
	containerClient, err := armstorage.NewBlobContainersClient(clients.SubscriptionID, clients.Cred, nil)
	if err != nil {
		return fmt.Errorf("failed to create container client: %w", err)
	}
	clients.ContainerClient = containerClient
	return nil
}

func (a *AzureClientInitializer) initShareClient(clients *AzureClients) error {
	shareClient, err := armstorage.NewFileSharesClient(clients.SubscriptionID, clients.Cred, nil)
	if err != nil {
		return fmt.Errorf("failed to create share client: %w", err)
	}
	clients.ShareClient = shareClient
	return nil
}

func (a *AzureClientInitializer) initQueueClient(clients *AzureClients) error {
	queueClient, err := armstorage.NewQueueClient(clients.SubscriptionID, clients.Cred, nil)
	if err != nil {
		return fmt.Errorf("failed to create queue client: %w", err)
	}
	clients.QueueClient = queueClient
	return nil
}

func InitTerraform(t *testing.T) (*terraform.Options, func()) {
	t.Helper()

	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)

	return tfOpts, func() {
		shared.Cleanup(t, tfOpts)
	}
}

func (f *AzureStorageFetcher) FetchResourceDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error) {
	accountClient, err := armstorage.NewAccountsClient(clients.SubscriptionID, clients.Cred, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create account client: %w", err)
	}

	resp, err := accountClient.GetProperties(ctx, resourceGroupName, accountName, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch storage account details: %w", err)
	}

	provisioningState := ""
	if resp.Account.Properties != nil && resp.Account.Properties.ProvisioningState != nil {
		provisioningState = string(*resp.Account.Properties.ProvisioningState)
	}

	return []ResourceDetail{{
		Name:              *resp.Account.Name,
		ResourceGroupName: resourceGroupName,
		ProvisioningState: provisioningState,
	}}, nil
}

func (f *AzureStorageFetcher) GetContainerDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error) {
	if clients.ContainerClient == nil {
		return nil, fmt.Errorf("container client is not initialized")
	}

	pager := clients.ContainerClient.NewListPager(resourceGroupName, accountName, nil)
	var details []ResourceDetail
	for pager.More() {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, container := range page.Value {
			details = append(details, ResourceDetail{
				Name: *container.Name,
			})
		}
	}
	return details, nil
}

func (f *AzureStorageFetcher) GetShareDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error) {
	if clients.ShareClient == nil {
		return nil, fmt.Errorf("share client is not initialized")
	}

	pager := clients.ShareClient.NewListPager(resourceGroupName, accountName, nil)
	var details []ResourceDetail
	for pager.More() {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, share := range page.Value {
			details = append(details, ResourceDetail{
				Name: *share.Name,
			})
		}
	}
	return details, nil
}

func (f *AzureStorageFetcher) GetQueueDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error) {
	if clients.QueueClient == nil {
		return nil, fmt.Errorf("queue client is not initialized")
	}

	pager := clients.QueueClient.NewListPager(resourceGroupName, accountName, nil)
	var details []ResourceDetail
	for pager.More() {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, queue := range page.Value {
			details = append(details, ResourceDetail{
				Name: *queue.Name,
			})
		}
	}
	return details, nil
}

func (v *StorageSubResourceVerifier) Verify(t *testing.T, details []ResourceDetail, expectedOutputs map[string]string) {
	for _, detail := range details {
		if _, exists := expectedOutputs[detail.Name]; !exists {
			t.Errorf("Resource %s found in Azure but not in Terraform output", detail.Name)
		}
	}

	for expectedName := range expectedOutputs {
		found := false
		for _, detail := range details {
			if detail.Name == expectedName {
				found = true
				break
			}
		}
		if !found {
			t.Errorf("Expected resource %s not found in actual Azure resources", expectedName)
		}
	}
}

func (v *StorageResourceVerifier) Verify(t *testing.T, details []ResourceDetail, expectedOutputs map[string]string) {
	for _, detail := range details {
		expectedName, nameExists := expectedOutputs["name"]
		expectedRGName, rgNameExists := expectedOutputs["resource_group_name"]

		if nameExists && detail.Name != expectedName {
			t.Errorf("StorageAccount name mismatch: expected %s, got %s", expectedName, detail.Name)
		}
		if rgNameExists && detail.ResourceGroupName != expectedRGName {
			t.Errorf("StorageAccount resource group name mismatch: expected %s, got %s", expectedRGName, detail.ResourceGroupName)
		}
		if detail.ProvisioningState != "Succeeded" {
			t.Errorf("StorageAccount provisioning state is not succeeded: got %s", detail.ProvisioningState)
		}
	}
}

func TestStorage(t *testing.T) {
	fetcher := &AzureStorageFetcher{}
	clientInitializer := &AzureClientInitializer{}
	tests := []struct {
		name             string
		fetchDetailsFunc func(context.Context, string, string, *AzureClients) ([]ResourceDetail, error)
		tfOutputKey      string
		verifier         StorageVerifier
	}{
		{"Containers", fetcher.GetContainerDetails, "containers", &StorageSubResourceVerifier{}},
		{"Shares", fetcher.GetShareDetails, "shares", &StorageSubResourceVerifier{}},
		{"Queues", fetcher.GetQueueDetails, "queues", &StorageSubResourceVerifier{}},
		{"StorageAccount", fetcher.FetchResourceDetails, "storage", &StorageResourceVerifier{}},
	}

	tfOpts, cleanup := InitTerraform(t)
	defer cleanup()

	config := TestConfig{
		subscriptionID:    terraform.Output(t, tfOpts, "subscription_id"),
		resourceGroupName: terraform.OutputMap(t, tfOpts, "storage")["resource_group_name"],
		accountName:       terraform.OutputMap(t, tfOpts, "storage")["name"],
		tfOpts:            tfOpts,
	}

	clients, err := clientInitializer.InitClients(config.subscriptionID)
	require.NoError(t, err, "Failed to initialize Azure clients")

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actualDetails, err := tt.fetchDetailsFunc(context.Background(), config.resourceGroupName, config.accountName, clients)
			require.NoError(t, err, "Failed to fetch details for %s", tt.name)

			expectedOutputs := terraform.OutputMap(t, config.tfOpts, tt.tfOutputKey)
			tt.verifier.Verify(t, actualDetails, expectedOutputs)
		})
	}
}
