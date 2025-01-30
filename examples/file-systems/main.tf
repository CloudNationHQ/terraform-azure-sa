module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.23"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 3.0"

  naming = local.naming

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    is_hns_enabled = true
    sftp_enabled   = true

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
          ace2 = {
            id = data.azurerm_client_config.current.object_id, permissions = "---", scope = "default", type = "user"
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
          cleansed = {
            owner = "$superuser"
            group = "$superuser"
            ace = {
              ace1 = {
                id = data.azurerm_client_config.current.object_id, permissions = "rw-", scope = "access", type = "user"
              }
              ace2 = {
                id = data.azurerm_client_config.current.object_id, permissions = "---", scope = "default", type = "user"
              }
            }
          }
          curated = {
            owner = data.azurerm_client_config.current.object_id
            group = "$superuser"
            ace = {
              ace1 = {
                id = data.azurerm_client_config.current.object_id, permissions = "r--", scope = "access", type = "user"
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
