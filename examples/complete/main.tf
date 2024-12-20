module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.22"

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
    name              = module.naming.storage_account.name_unique
    location          = module.rg.groups.demo.location
    resource_group    = module.rg.groups.demo.name
    threat_protection = true


    local_user_enabled = true
    dns_endpoint_type  = "Standard"

    blob_properties   = local.blob_properties
    queue_properties  = local.queue_properties
    share_properties  = local.share_properties
    management_policy = local.management_policy

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
