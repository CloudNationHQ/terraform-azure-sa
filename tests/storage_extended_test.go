package main

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/cloudnationhq/terraform-azure-sa/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type StorageDetails struct {
	ResourceGroupName string
	Name              string
}

type ClientSetup struct {
	SubscriptionID string
	StorageClient  *armstorage.AccountsClient
}

func (details *StorageDetails) GetStorage(t *testing.T, client *armstorage.AccountsClient) *armstorage.Account {
	resp, err := client.GetProperties(context.Background(), details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get storage account")
	return &resp.Account
}

func (setup *ClientSetup) InitializeStorageClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.StorageClient, err = armstorage.NewAccountsClient(setup.SubscriptionID, cred, nil)
	require.NoError(t, err, "Failed to initialize storage client")
}

func TestStorage(t *testing.T) {
	t.Run("VerifyStorage", func(t *testing.T) {
		t.Parallel()

		cred, err := azidentity.NewDefaultAzureCredential(nil)
		require.NoError(t, err, "Failed to get credentials")

		tfOpts := shared.GetTerraformOptions("../examples/complete")
		defer shared.Cleanup(t, tfOpts)
		terraform.InitAndApply(t, tfOpts)

		storageMap := terraform.OutputMap(t, tfOpts, "storage")
		subscriptionID := terraform.Output(t, tfOpts, "subscriptionId")

		storageDetails := &StorageDetails{
			ResourceGroupName: storageMap["resource_group_name"],
			Name:              storageMap["name"],
		}

		clientSetup := &ClientSetup{SubscriptionID: subscriptionID}
		clientSetup.InitializeStorageClient(t, cred)
		storage := storageDetails.GetStorage(t, clientSetup.StorageClient)

		t.Run("verifyStorage", func(t *testing.T) {
			verifyStorage(t, storageDetails, storage)
		})
	})
}

func verifyStorage(t *testing.T, details *StorageDetails, storage *armstorage.Account) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*storage.Name,
		"Storage name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*storage.Properties.ProvisioningState),
		"Storage provisioning state is not succeeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "st"),
		"Storage name does not start with the right abbreviation",
	)
}
