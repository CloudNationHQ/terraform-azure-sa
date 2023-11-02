# generate random id
resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

# dns zone
data "azurerm_private_dns_zone" "zone" {
  name                = var.zone.name
  resource_group_name = var.zone.resourcegroup
}

# network link
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "link${random_string.random.result}"
  resource_group_name   = var.zone.resourcegroup
  private_dns_zone_name = data.azurerm_private_dns_zone.zone.name
  virtual_network_id    = var.zone.vnet
  registration_enabled  = try(var.zone.registration_enabled, true)
}
