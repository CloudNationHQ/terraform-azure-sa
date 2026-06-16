moved {
  from = azurerm_storage_account.sa
  to   = azurerm_storage_account.this
}

moved {
  from = azurerm_storage_container.sc
  to   = azurerm_storage_container.this
}

moved {
  from = azurerm_storage_container_immutability_policy.immutability_policy
  to   = azurerm_storage_container_immutability_policy.this
}

moved {
  from = azurerm_storage_queue.sq
  to   = azurerm_storage_queue.this
}

moved {
  from = azurerm_storage_account_local_user.lu
  to   = azurerm_storage_account_local_user.this
}

moved {
  from = azurerm_storage_share.sh
  to   = azurerm_storage_share.this
}

moved {
  from = azurerm_storage_table.st
  to   = azurerm_storage_table.this
}

moved {
  from = azurerm_storage_data_lake_gen2_filesystem.fs
  to   = azurerm_storage_data_lake_gen2_filesystem.this
}

moved {
  from = azurerm_storage_data_lake_gen2_path.pa
  to   = azurerm_storage_data_lake_gen2_path.this
}

moved {
  from = azurerm_storage_management_policy.mgmt_policy["default"]
  to   = azurerm_storage_management_policy.this["this"]
}

moved {
  from = azurerm_role_assignment.managed_identity["identity"]
  to   = azurerm_role_assignment.this["this"]
}
