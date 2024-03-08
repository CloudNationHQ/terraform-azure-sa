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
      region = "northeurope"
    }
  }
}

module "storage" {
  source = "../../"

  naming = local.naming

  storage = {
    name              = module.naming.storage_account.name_unique
    location          = module.rg.groups.demo.location
    resourcegroup     = module.rg.groups.demo.name
    threat_protection = true

    blob_properties  = local.blob_properties
    queue_properties = local.queue_properties
    share_properties = local.share_properties
    mgt_policy       = local.mgt_policy

    policy = {
      sas = {
        expiration_action = "Log"
        expiration_period = "07.05:13:22"
      }
    }

    routing = {
      publish_internet_endpoints = true
    }
  }
}
