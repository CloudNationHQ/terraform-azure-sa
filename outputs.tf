output "account" {
  description = "storage account details"
  value = azurerm_storage_account.sa
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value = data.azurerm_subscription.current.subscription_id
}

output "containers" {
  description = "container configuration specifics"
  value = azurerm_storage_container.sc
}

output "shares" {
  description = "shares configuration specifics"
  value = azurerm_storage_share.sh
}

output "queues" {
  description = "queues configuration specifics"
  value = azurerm_storage_queue.sq
}

output "tables" {
  description = "tables configuration specifics"
  value = azurerm_storage_table.st
}
