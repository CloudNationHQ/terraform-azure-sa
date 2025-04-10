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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        address_prefixes = ["10.19.1.0/24"]
        service_endpoints = [
          "Microsoft.Storage",
        ]
      }
    }
  }
}

module "law" {
  source  = "cloudnationhq/law/azure"
  version = "~> 2.0"

  workspace = {
    name           = module.naming.log_analytics_workspace.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "dcr" {
  source  = "cloudnationhq/dcr/azure"
  version = "~> 2.0"

  rule = {
    name           = module.naming.data_collection_rule.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    data_flow = {
      df1 = {
        streams      = ["Microsoft-InsightsMetrics"]
        destinations = ["la1"]
      }
    }

    destinations = {
      log_analytics = {
        la1 = {
          workspace_resource_id = module.law.workspace.id
        }
      }
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 3.0"

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    network_rules = {
      virtual_network_subnet_ids = [module.network.subnets.sn1.id]
      private_link_access = {
        dcr = {
          endpoint_resource_id = module.dcr.rule.default.id
        }
      }
    }
  }
}
