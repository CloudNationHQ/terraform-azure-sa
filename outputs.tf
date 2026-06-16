output "storage" {
  description = "storage account details"
  value       = azurerm_storage_account.this
}

output "containers" {
  description = "container configuration specifics"
  value       = azurerm_storage_container.this
}

output "shares" {
  description = "shares configuration specifics"
  value       = azurerm_storage_share.this
}

output "queues" {
  description = "queues configuration specifics"
  value       = azurerm_storage_queue.this
}

output "queue_properties" {
  description = "queue properties configuration specifics"
  value       = azurerm_storage_account_queue_properties.this
}

output "tables" {
  description = "tables configuration specifics"
  value       = azurerm_storage_table.this
}

output "file_systems" {
  description = "file systems configuration specifics"
  value       = azurerm_storage_data_lake_gen2_filesystem.this
}

output "file_system_paths" {
  description = "file system paths configuration specifics"
  value       = azurerm_storage_data_lake_gen2_path.this
}

output "management_policy" {
  description = "management policy configuration specifics"
  value       = azurerm_storage_management_policy.this
}

output "container_immutability_policies" {
  description = "container immutability policy configuration specifics"
  value       = azurerm_storage_container_immutability_policy.this
}

output "local_users" {
  description = "local user configuration specifics"
  value       = azurerm_storage_account_local_user.this
}

output "role_assignments" {
  description = "role assignment configuration specifics"
  value       = azurerm_role_assignment.this
}

output "private_endpoints" {
  description = "private endpoint configuration specifics"
  value       = azurerm_private_endpoint.this
}
