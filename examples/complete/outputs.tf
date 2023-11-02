output "storage" {
  description = "storage account details"
  value     = module.storage.account
  sensitive = true
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value = module.storage.subscriptionId
}
