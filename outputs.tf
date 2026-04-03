output "account" {
  description = "storage account details"
  value       = azurerm_storage_account.sa
}

output "containers" {
  description = "container configuration specifics"
  value       = azurerm_storage_container.sc
}

output "shares" {
  description = "shares configuration specifics"
  value       = azurerm_storage_share.sh
}

output "queues" {
  description = "queues configuration specifics"
  value       = azurerm_storage_queue.sq
}

output "tables" {
  description = "tables configuration specifics"
  value       = azurerm_storage_table.st
}

output "file_systems" {
  description = "file systems configuration specifics"
  value       = azurerm_storage_data_lake_gen2_filesystem.fs
}

output "file_system_paths" {
  description = "file system paths configuration specifics"
  value       = azurerm_storage_data_lake_gen2_path.pa
}

output "management_policy" {
  description = "management policy configuration specifics"
  value       = azurerm_storage_management_policy.mgmt_policy
}

output "container_immutability_policies" {
  description = "container immutability policy configuration specifics"
  value       = azurerm_storage_container_immutability_policy.immutability_policy
}

output "local_users" {
  description = "local user configuration specifics"
  value       = azurerm_storage_account_local_user.lu
}

output "role_assignments" {
  description = "role assignment configuration specifics"
  value       = azurerm_role_assignment.managed_identity
}
