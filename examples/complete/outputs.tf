#output "storage" {
  #description = "storage account details"
  #value       = module.storage.account
  #sensitive   = true
#}

output "storage" {
  value = {
    id   = module.storage.account.id
    name = module.storage.account.name
    resource_group_name = module.storage.account.resource_group_name
  }
}

output "shares" {
  description = "share details"
  value = {
    for s in module.storage.shares : s.name => {
      id   = s.id
      name = s.name
    }
  }
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

output "queues" {
  description = "queue details"
  value = {
    for q in module.storage.queues : q.name => {
      id   = q.id
      name = q.name
    }
  }
}

output "subscription_id" {
  description = "contains the current subscription id"
  value       = module.storage.subscriptionId
}
