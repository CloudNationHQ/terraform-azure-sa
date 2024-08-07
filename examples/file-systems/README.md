This sample demonstrates configuring storage file systems, facilitating file systems (containers) for adls gen 2 datalake storage, when hierarchical namespacing is enabled.

## Usage

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.23"

  naming = local.naming

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    is_hns_enabled = true

    file_systems = {
      fs1 = {
        owner = data.azurerm_client_config.current.object_id
        group = "$superuser"
        properties = {
          env = "RGF0YWxha2U=" # Base64 encoded string - Datalake
        }

        ace = {
          ace1 = {
            id = data.azurerm_client_config.current.object_id, permissions = "rwx", scope = "access", type = "user"
          }
        }

        paths = {
          raw = {
            owner = "$superuser"
            group = "$superuser"
            ace = {
              ace1 = {
                id = data.azurerm_client_config.current.object_id, permissions = "rwx", scope = "access", type = "user"
              }
              ace2 = {
                id = data.azurerm_client_config.current.object_id, permissions = "---", scope = "default", type = "user"
              }
            }
          }
        }
      }
    }
  }
}
```
