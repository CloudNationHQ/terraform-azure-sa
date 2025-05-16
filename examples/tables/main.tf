module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

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
  version = "~> 4.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    tables = {
      tb1 = {
        acl = {
          acl1 = {
            access_policy = {
              permissions = "r"
              start       = "2025-07-02T09:38:21Z"
              expiry      = "2026-07-02T10:38:21Z"
            }
          }
          acl2 = {
            access_policy = {
              permissions = "raud" #Read, Add, Update, Delete
              start       = "2025-08-01T09:38:21Z"
              expiry      = "2026-08-01T10:38:21Z"
            }
          }
        }
      }
    }
  }
}
