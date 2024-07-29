This sample demonstrates configuring storage shares, facilitating file sharing with defined access levels for secure and collaborative work environments.

## Usage

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.23"

  naming = local.naming

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    share_properties = {
      smb = {
        versions             = ["SMB3.1.1"]
        authentication_types = ["Kerberos"]
      }

      retention_policy = {
        days = 8
      }

      shares = {
        fs1 = {
          quota = 50
          metadata = {
            environment = "dev"
            owner       = "finance team"
          }
          acl = {
            id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
            access_policy = {
              permissions = "r"
              start       = "2019-07-02T09:38:21.0000000Z"
              expiry      = "2019-07-02T10:38:21.0000000Z"
            }
          }
        }
      }
    }
  }
}
```
