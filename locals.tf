locals {
  containers = flatten([
    for sc_key, sc in try(var.storage.blob_properties.containers, {}) : {

      sc_key                = sc_key
      name                  = try(sc.name, join("-", [var.naming.storage_container, sc_key]))
      container_access_type = try(sc.access_type, "private")
      metadata              = try(sc.metadata, {})
    }
  ])
}

locals {
  shares = flatten([
    for fs_key, fs in try(var.storage.share_properties.shares, {}) : {

      fs_key           = fs_key
      name             = try(fs.name, join("-", [var.naming.storage_share, fs_key]))
      quota            = fs.quota
      metadata         = try(fs.metadata, {})
      access_tier      = try(fs.access_tier, "Hot")
      enabled_protocol = try(fs.protocol, "SMB")
      acl              = try(fs.acl, {})
    }
  ])
}

locals {
  queues = flatten([
    for sq_key, sq in try(var.storage.queue_properties.queues, {}) : {

      sq_key               = sq_key
      name                 = try(sq.name, join("-", [var.naming.storage_queue, sq_key]))
      storage_account_name = azurerm_storage_account.sa.name
      metadata             = try(sq.metadata, {})
    }
  ])
}

locals {
  tables = flatten([
    for st_key, st in try(var.storage.tables, {}) : {

      st_key               = st_key
      name                 = try(st.name, join("-", [var.naming.storage_table, st_key]))
      storage_account_name = azurerm_storage_account.sa.name
    }
  ])
}

locals {
  file_systems = flatten([
    for fs_key, fs in try(var.storage.file_systems, {}) : {

      fs_key                   = fs_key
      name                     = try(fs.name, join("-", [var.naming.storage_data_lake_gen2_filesystem, fs_key]))
      storage_account_id       = azurerm_storage_account.sa.id
      properties               = try(fs.properties, {})
      owner                    = try(fs.owner, null)
      group                    = try(fs.group, null)
      default_encryption_scope = try(fs.default_encryption_scope, null)
      ace                      = try(fs.ace, {})
    }
  ])
}

locals {
  fs_paths = flatten([
    for fs_key, fs in try(var.storage.file_systems, {}) : [
      for pa_key, pa in try(fs.paths, {}) : {

        pa_key             = pa_key
        path               = try(pa.path, pa_key)
        filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fs[fs_key].name
        storage_account_id = azurerm_storage_account.sa.id
        owner              = try(pa.owner, null)
        group              = try(pa.group, null)
        ace                = try(pa.ace, {})
      }
  ]])
}
