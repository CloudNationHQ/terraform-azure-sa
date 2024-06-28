This example demonstrates configuring blob storage containers, where tailored access rules ensure secure and organized data interaction for services.

## Usage

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.19"

  naming = local.naming

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    blob_properties = {
      versioning_enabled       = true
      last_access_time_enabled = true
      change_feed_enabled      = true

      restore_policy = {
        days = 8
      }

      delete_retention_policy = {
        days = 10
      }

      container_delete_retention_policy = {
        days = 10
      }

      containers = {
        sc1 = {
          metadata = {
            project = "marketing"
            owner   = "marketing team"
          }
        }
      }
    }
  }
}
```
