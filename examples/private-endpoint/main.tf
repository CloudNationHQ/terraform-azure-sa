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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 2.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        nsg  = {}
        cidr = ["10.19.1.0/24"]
      }
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    public_network_access_enabled = false
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name

  zones = {
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

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  endpoints = local.endpoints
}
