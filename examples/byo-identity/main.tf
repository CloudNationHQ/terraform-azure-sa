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
  version = "~> 1.0"

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    identity       = {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.identity.id]
    }
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location
}