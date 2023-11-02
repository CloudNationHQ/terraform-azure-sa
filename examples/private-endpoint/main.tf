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

module "network" {
  source = "github.com/cloudnationhq/az-cn-module-tf-vnet"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
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

    private_endpoint = {
      name         = module.naming.private_endpoint.name
      dns_zones    = [module.private_dns.zone.id]
      subnet       = module.network.subnets.sn1.id
      subresources = ["blob"]
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/sa/modules/private-dns/azure"
  version = "~> 0.1"

  providers = {
    azurerm = azurerm.connectivity
  }

  zone = {
    name          = "privatelink.blob.core.windows.net"
    resourcegroup = "rg-dns-shared-001"
    vnet          = module.network.vnet.id
  }
}
