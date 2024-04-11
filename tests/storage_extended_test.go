package main

import (
	"context"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/cloudnationhq/terraform-azure-sa/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type ResourceFetcher interface {
	InitClient(subscriptionID string, cred *azidentity.DefaultAzureCredential) error
	FetchDetails(ctx context.Context, resourceGroupName, accountName string) ([]ResourceDetail, error)
}

type AzureClients struct {
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
	Name string
}

type ContainerFetcher struct {
	client *armstorage.BlobContainersClient
}

type SharesFetcher struct {
	client *armstorage.FileSharesClient
}

type QueuesFetcher struct {
	client *armstorage.QueueClient
}

func InitTerraform(t *testing.T) (*terraform.Options, func()) {
	t.Helper()

	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)

	return tfOpts, func() {
		shared.Cleanup(t, tfOpts)
	}
}

func (cf *ContainerFetcher) InitClient(subscriptionID string, cred *azidentity.DefaultAzureCredential) error {
	var err error
	cf.client, err = armstorage.NewBlobContainersClient(subscriptionID, cred, nil)
	return err
}

func (cf *ContainerFetcher) FetchDetails(ctx context.Context, resourceGroupName, accountName string) ([]ResourceDetail, error) {
	pager := cf.client.NewListPager(resourceGroupName, accountName, nil)
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

func (sf *SharesFetcher) InitClient(subscriptionID string, cred *azidentity.DefaultAzureCredential) error {
	var err error
	sf.client, err = armstorage.NewFileSharesClient(subscriptionID, cred, nil)
	return err
}

func (sf *SharesFetcher) FetchDetails(ctx context.Context, resourceGroupName, accountName string) ([]ResourceDetail, error) {
	pager := sf.client.NewListPager(resourceGroupName, accountName, nil)
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

func (qf *QueuesFetcher) InitClient(subscriptionID string, cred *azidentity.DefaultAzureCredential) error {
	var err error
	qf.client, err = armstorage.NewQueueClient(subscriptionID, cred, nil)
	return err
}

func (qf *QueuesFetcher) FetchDetails(ctx context.Context, resourceGroupName, accountName string) ([]ResourceDetail, error) {
	pager := qf.client.NewListPager(resourceGroupName, accountName, nil)
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

func initAndFetchResources(t *testing.T, subscriptionID, resourceGroupName, accountName string, fetcher ResourceFetcher) []ResourceDetail {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "Failed to get credentials")

	err = fetcher.InitClient(subscriptionID, cred)
	require.NoError(t, err, "Failed to initialize client")

	details, err := fetcher.FetchDetails(context.Background(), resourceGroupName, accountName)
	require.NoError(t, err, "Failed to fetch details")

	return details
}

func verifyResource(t *testing.T, config TestConfig, resourceType string, fetcher ResourceFetcher, tfOutputKey string) {
	expectedOutput := terraform.OutputMap(t, config.tfOpts, tfOutputKey)
	actualDetails := initAndFetchResources(t, config.subscriptionID, config.resourceGroupName, config.accountName, fetcher)

	for _, detail := range actualDetails {
		if _, exists := expectedOutput[detail.Name]; !exists {
			t.Errorf("%s %s found in Azure but not in Terraform output", resourceType, detail.Name)
		}
	}

	for expectedName := range expectedOutput {
		found := false
		for _, detail := range actualDetails {
			if detail.Name == expectedName {
				found = true
				break
			}
		}
		if !found {
			t.Errorf("Expected %s %s not found in actual Azure resources", resourceType, expectedName)
		}
	}
}

func TestStorageSubResources(t *testing.T) {
	tfOpts, cleanup := InitTerraform(t)
	defer cleanup()

	config := TestConfig{
		subscriptionID:    terraform.Output(t, tfOpts, "subscription_id"),
		resourceGroupName: terraform.OutputMap(t, tfOpts, "storage")["resource_group_name"],
		accountName:       terraform.OutputMap(t, tfOpts, "storage")["name"],
		tfOpts:            tfOpts,
	}

	resourceTypes := []struct {
		name        string
		fetcher     ResourceFetcher
		tfOutputKey string
	}{
		{"Containers", &ContainerFetcher{}, "containers"},
		{"Shares", &SharesFetcher{}, "shares"},
		{"Queues", &QueuesFetcher{}, "queues"},
	}

	for _, rt := range resourceTypes {
		t.Run("Verify"+rt.name, func(t *testing.T) {
			verifyResource(t, config, rt.name, rt.fetcher, rt.tfOutputKey)
		})
	}
}
