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
	InitClient(subscriptionID string, cred *azidentity.DefaultAzureCredential, clients *AzureClients) error
	FetchResourceDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error)
}

type StorageVerifier interface {
	Verify(t *testing.T, details []ResourceDetail, expectedOutputs map[string]string)
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

func initAzureClients(subscriptionID string) (*AzureClients, error) {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create credentials: %w", err)
	}

	clients := &AzureClients{
		SubscriptionID: subscriptionID,
		Cred:           cred,
	}

	var clientErr error
	clients.ContainerClient, clientErr = armstorage.NewBlobContainersClient(subscriptionID, cred, nil)
	if clientErr != nil {
		return nil, clientErr
	}
	clients.ShareClient, clientErr = armstorage.NewFileSharesClient(subscriptionID, cred, nil)
	if clientErr != nil {
		return nil, clientErr
	}
	clients.QueueClient, clientErr = armstorage.NewQueueClient(subscriptionID, cred, nil)
	if clientErr != nil {
		return nil, clientErr
	}
	return clients, nil
}

func InitTerraform(t *testing.T) (*terraform.Options, func()) {
	t.Helper()

	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)

	return tfOpts, func() {
		shared.Cleanup(t, tfOpts)
	}
}

func (f *AzureStorageFetcher) GetStorageDetails(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error) {
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
	for {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, container := range page.Value {
			details = append(details, ResourceDetail{
				Name: *container.Name,
			})
		}
		if page.NextLink == nil || len(*page.NextLink) == 0 {
			break
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
	for {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, share := range page.Value {
			details = append(details, ResourceDetail{
				Name: *share.Name,
			})
		}
		if page.NextLink == nil || len(*page.NextLink) == 0 {
			break
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
	for {
		page, err := pager.NextPage(ctx)
		if err != nil {
			return nil, err
		}
		for _, queue := range page.Value {
			details = append(details, ResourceDetail{
				Name: *queue.Name,
			})
		}
		if page.NextLink == nil || len(*page.NextLink) == 0 {
			break
		}
	}
	return details, nil
}

func initAndFetchResources(t *testing.T, subscriptionID, resourceGroupName, accountName string, clients *AzureClients, fetcher StorageFetcher) ([]ResourceDetail, error) {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "Failed to get credentials")

	err = fetcher.InitClient(subscriptionID, cred, clients)
	require.NoError(t, err, "Failed to initialize client")

	details, err := fetcher.FetchResourceDetails(context.Background(), resourceGroupName, accountName, clients)
	require.NoError(t, err, "Failed to fetch details")

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
	tfOpts, cleanup := InitTerraform(t)
	defer cleanup()

	config := TestConfig{
		subscriptionID:    terraform.Output(t, tfOpts, "subscription_id"),
		resourceGroupName: terraform.OutputMap(t, tfOpts, "storage")["resource_group_name"],
		accountName:       terraform.OutputMap(t, tfOpts, "storage")["name"],
		tfOpts:            tfOpts,
	}

	clients, err := initAzureClients(config.subscriptionID)
	if err != nil {
		t.Fatalf("Failed to initialize Azure clients: %v", err)
	}

	azureFetcher := AzureStorageFetcher{}

	verifierMap := map[string]StorageVerifier{
		"Containers":     &StorageSubResourceVerifier{},
		"Shares":         &StorageSubResourceVerifier{},
		"Queues":         &StorageSubResourceVerifier{},
		"StorageAccount": &StorageResourceVerifier{},
	}

	t.Run("SubResources", func(t *testing.T) {
		resourceTypes := []struct {
			name             string
			fetchDetailsFunc func(ctx context.Context, resourceGroupName, accountName string, clients *AzureClients) ([]ResourceDetail, error)
			tfOutputKey      string
		}{
			{"Containers", azureFetcher.GetContainerDetails, "containers"},
			{"Shares", azureFetcher.GetShareDetails, "shares"},
			{"Queues", azureFetcher.GetQueueDetails, "queues"},
			{"StorageAccount", azureFetcher.GetStorageDetails, "storage"},
		}

		for _, rt := range resourceTypes {
			t.Run("Verify"+rt.name, func(t *testing.T) {
				actualDetails, err := rt.fetchDetailsFunc(context.Background(), config.resourceGroupName, config.accountName, clients)
				if err != nil {
					t.Errorf("Failed to fetch details for %s: %v", rt.name, err)
					return
				}
				expectedOutputs := terraform.OutputMap(t, config.tfOpts, rt.tfOutputKey)
				verifier := verifierMap[rt.name]
				verifier.Verify(t, actualDetails, expectedOutputs)
			})
		}
	})
}
