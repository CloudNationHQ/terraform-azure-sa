package main

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/cloudnationhq/terraform-azure-sa/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type StorageAccountDetails struct {
	ResourceGroupName string
	AccountName       string
	Containers        []ContainerDetails
}

type ContainerDetails struct {
	Name string
}

type ClientSetup struct {
	SubscriptionId   string
	StorageClient    *armstorage.AccountsClient
	ContainersClient *armstorage.BlobContainersClient
}

func (setup *ClientSetup) InitStorageClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.StorageClient, err = armstorage.NewAccountsClient(setup.SubscriptionId, cred, nil)
	require.NoError(t, err,
		"Failed to create credential",
	)
}

func (setup *ClientSetup) InitContainersClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.ContainersClient, err = armstorage.NewBlobContainersClient(setup.SubscriptionId, cred, nil)
	require.NoError(t, err,
		"Failed to create credential",
	)
}

func (details *StorageAccountDetails) GetStorage(t *testing.T, client *armstorage.AccountsClient) *armstorage.Account {
	ctx := context.Background()
	resp, err := client.GetProperties(ctx, details.ResourceGroupName, details.AccountName, nil)
	require.NoError(t, err,
		"Failed to get storage account",
	)
	return &resp.Account
}

func (details *StorageAccountDetails) GetContainers(t *testing.T, client *armstorage.BlobContainersClient) []ContainerDetails {
	pager := client.NewListPager(details.ResourceGroupName, details.AccountName, nil)
	var containers []ContainerDetails
	for {
		page, err := pager.NextPage(context.Background())
		require.NoError(t, err,
			"Failed to fetch the next page of containers",
		)

		for _, container := range page.Value {
			containers = append(containers, ContainerDetails{
				Name: *container.Name,
			})
		}
		if page.NextLink == nil || len(*page.NextLink) == 0 {
			break
		}
	}
	return containers
}

func InitTerraform(t *testing.T) (*terraform.Options, func()) {
	t.Helper()

	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)

	return tfOpts, func() {
		shared.Cleanup(t, tfOpts)
	}
}

func GetAzureCredentials(t *testing.T) *azidentity.DefaultAzureCredential {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err,
		"Failed to get credentials",
	)
	return cred
}

func TestStorageAccount(t *testing.T) {
	t.Run("VerifyStorage", func(t *testing.T) {
		t.Parallel()
		tfOpts, cleanup := InitTerraform(t)
		defer cleanup()

		subscriptionId := terraform.Output(t, tfOpts, "subscriptionId")
		require.NotEmpty(t, subscriptionId,
			"Subscription ID not found in terraform output",
		)

		clientSetup := InitClients(t, subscriptionId)

		storageAccountMap := terraform.OutputMap(t, tfOpts, "storage")
		accountName := storageAccountMap["name"]
		resourceGroupName := storageAccountMap["resource_group_name"]

		VerifyStorage(t, tfOpts, clientSetup)

		VerifyContainers(t, clientSetup, &StorageAccountDetails{
			ResourceGroupName: resourceGroupName,
			AccountName:       accountName,
		}, tfOpts)
	})
}

func InitClients(t *testing.T, subscriptionId string) *ClientSetup {
	clientSetup := &ClientSetup{SubscriptionId: subscriptionId}
	cred := GetAzureCredentials(t)
	clientSetup.InitStorageClient(t, cred)
	clientSetup.InitContainersClient(t, cred)
	return clientSetup
}

func VerifyStorage(t *testing.T, tfOpts *terraform.Options, clientSetup *ClientSetup) {
	t.Run("VerifyAccount", func(t *testing.T) {
		t.Helper()

		storageAccountMap := terraform.OutputMap(t, tfOpts, "storage")

		accountName, ok := storageAccountMap["name"]
		require.True(t, ok,
			"Storage account name not found in terraform output",
		)

		resourceGroupName, ok := storageAccountMap["resource_group_name"]
		require.True(t, ok,
			"Resource group name not found in terraform output",
		)

		storageAccountDetails := &StorageAccountDetails{
			ResourceGroupName: resourceGroupName,
			AccountName:       accountName,
		}

		storageAccount := storageAccountDetails.GetStorage(t, clientSetup.StorageClient)
		require.NotNil(t, storageAccount,
			"Failed to retrieve storage account details",
		)

		require.Equal(t, accountName, *storageAccount.Name,
			"Storage account name does not match expected value this one",
		)

		require.Equal(t, "Succeeded", string(*storageAccount.Properties.ProvisioningState),
			"Storage account provisioning state is not Succeeded",
		)

		require.True(t, strings.HasPrefix(accountName, "st"),
			"Storage account name does not start with the right abbreviation",
		)
	})
}

func VerifyContainers(t *testing.T, setup *ClientSetup, storageAccountDetails *StorageAccountDetails, tfOpts *terraform.Options) {
	t.Run("VerifyContainers", func(t *testing.T) {
		t.Helper()

		containersData := storageAccountDetails.GetContainers(t, setup.ContainersClient)

		containersOutput := terraform.OutputMap(t, tfOpts, "containers")
		require.NotEmpty(t, containersOutput, "Containers output is empty")

		for _, containerData := range containersData {
			containerName := containerData.Name
			assert.NotEmpty(t, containerName, "Container name not found in Azure response")

			_, exists := containersOutput[containerName]
			assert.True(t, exists, "Container %s found in Azure but not in Terraform output", containerName)
		}
	})
}
