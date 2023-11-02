module "naming" {
  source = "github.com/cloudnationhq/az-cn-module-tf-naming"

  suffix = ["demo", "dev"]
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

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

    queue_properties = {
      logging = {
        read              = true
        retention_in_days = 8
      }

      queues = {
        q1 = {
          metadata = {
            environment = "dev"
            owner       = "finance team"
            purpose     = "transaction_processing"
          }
        }
      }
    }
  }
}
