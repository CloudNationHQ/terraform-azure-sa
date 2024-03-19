output "storage" {
  description = "storage account details"
  value       = module.storage.account
  sensitive   = true
}

output "containers" {
  description = "container details"
  value = {
    for c in module.storage.containers : c.name => {
      id   = c.id
      name = c.name
    }
  }
}

output "subscriptionId" {
  description = "contains the current subscription id"
  value       = module.storage.subscriptionId
}
