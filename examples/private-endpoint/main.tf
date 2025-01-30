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
        network_security_group = {}
        address_prefixes       = ["10.19.1.0/24"]
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

    public_network_access_enabled = false
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 3.0"

  resource_group = module.rg.groups.demo.name

  zones = {
    private = {
      blob = {
        name = "privatelink.blob.core.windows.net"
        virtual_network_links = {
          link1 = {
            virtual_network_id   = module.network.vnet.id
            registration_enabled = true
          }
        }
      }
    }
  }
}

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  endpoints = {
    blob = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.storage.account.id
      private_dns_zone_ids           = [module.private_dns.private_zones.blob.id]
      subresource_names              = ["blob"]
    }
  }
}
