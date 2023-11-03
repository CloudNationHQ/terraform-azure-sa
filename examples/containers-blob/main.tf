module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

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
