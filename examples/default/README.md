This example illustrates the default storage setup, in its simplest form.

## Usage: default

```hcl
module "storage" {
  source = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}
```

## Usage: multiple

Additionally, for certain scenarios, the example below highlights the ability to use multiple storage accounts, enabling a broader setup.

```hcl
module "storage" {
  source = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  for_each = local.storage

  naming  = local.naming
  storage = each.value
}
```

The module uses a local to iterate, generating a storage account for each key.

```hcl
locals {
  storage = {
    sa1 = {
      name          = join("", [module.naming.storage_account.name_unique, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name

      share_properties = {
        smb = {
          versions             = ["SMB3.1.1"]
          authentication_types = ["Kerberos"]
          multichannel_enabled = false
        }

        shares = {
          operations = {
            quota = 50
            metadata = {
              environment = "dev"
              owner       = "operations team"
            }
          }
        }
      }
    },
    sa2 = {
      name          = join("", [module.naming.storage_account.name_unique, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name

      share_properties = {
        smb = {
          versions             = ["SMB3.1.1"]
          authentication_types = ["Kerberos"]
          multichannel_enabled = false
        }

        shares = {
          finance = {
            quota = 50
            metadata = {
              environment = "prd"
              owner       = "finance team"
            }
          }
        }
      }
    }
  }
}
```

The below maps resource types to their corresponding outputs from the naming module, ensuring consistent naming conventions across resources

```hcl
locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["storage_container", "storage_share", "storage_queue", "storage_table"]
}
```
