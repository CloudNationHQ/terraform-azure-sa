output "zone" {
  value = {
    id = data.azurerm_private_dns_zone.zone.id
  }
}
