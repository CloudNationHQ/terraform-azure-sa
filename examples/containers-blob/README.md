This example demonstrates configuring blob storage containers, where tailored access rules ensure secure and organized data interaction for services.

## Usage

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.9"

  naming = local.naming

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    blob_properties = {
      versioning               = true
      last_access_time         = true
      change_feed              = true
      restore_policy           = true
      delete_retention_in_days = 8
      restore_in_days          = 7

      containers = {
        sc1 = {
          access_type = "private"
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
