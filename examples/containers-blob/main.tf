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

    blob_properties = {
      versioning_enabled       = true
      last_access_time_enabled = true
      change_feed_enabled      = true

      restore_policy = {
        days = 8
      }

      delete_retention_policy = {
        days                     = 10
        permanent_delete_enabled = false
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
