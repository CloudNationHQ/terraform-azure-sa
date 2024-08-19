This example illustrates the storage setup when using an already existing User Assigned Identity

## Usage: default

```hcl
module "storage" {
  source = "cloudnationhq/sa/azure"
  version = "~> 1.0"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    identity = {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.identity.id]
    }
  }
}
```