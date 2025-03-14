# storage accounts
resource "azurerm_storage_account" "sa" {
  name                              = var.storage.name
  resource_group_name               = coalesce(lookup(var.storage, "resource_group", null), var.resource_group)
  location                          = coalesce(lookup(var.storage, "location", null), var.location)
  account_tier                      = try(var.storage.account_tier, "Standard")
  account_replication_type          = try(var.storage.account_replication_type, "GRS")
  account_kind                      = try(var.storage.account_kind, "StorageV2")
  access_tier                       = try(var.storage.access_tier, "Hot")
  infrastructure_encryption_enabled = try(var.storage.infrastructure_encryption_enabled, false)
  https_traffic_only_enabled        = try(var.storage.https_traffic_only_enabled, true)
  min_tls_version                   = try(var.storage.min_tls_version, "TLS1_2")
  edge_zone                         = try(var.storage.edge_zone, null)
  table_encryption_key_type         = try(var.storage.table_encryption_key_type, null)
  queue_encryption_key_type         = try(var.storage.queue_encryption_key_type, null)
  allowed_copy_scope                = try(var.storage.allowed_copy_scope, null)
  large_file_share_enabled          = try(var.storage.large_file_share_enabled, false)
  allow_nested_items_to_be_public   = try(var.storage.allow_nested_items_to_be_public, false)
  shared_access_key_enabled         = try(var.storage.shared_access_key_enabled, true)
  public_network_access_enabled     = try(var.storage.public_network_access_enabled, true)
  is_hns_enabled                    = try(var.storage.is_hns_enabled, false)
  sftp_enabled                      = try(var.storage.sftp_enabled, false)
  nfsv3_enabled                     = try(var.storage.nfsv3_enabled, false)
  cross_tenant_replication_enabled  = try(var.storage.cross_tenant_replication_enabled, false)
  local_user_enabled                = try(var.storage.local_user_enabled, null)
  dns_endpoint_type                 = try(var.storage.dns_endpoint_type, null)
  default_to_oauth_authentication   = try(var.storage.default_to_oauth_authentication, false)
  tags                              = try(var.storage.tags, var.tags, null)

  dynamic "network_rules" {
    for_each = try(var.storage.network_rules, null) != null ? [var.storage.network_rules] : []

    content {
      bypass                     = try(network_rules.value.bypass, ["None"])
      default_action             = try(network_rules.value.default_action, "Deny")
      ip_rules                   = try(network_rules.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, null)

      dynamic "private_link_access" {
        for_each = { for key, pla in try(var.storage.network_rules.private_link_access, {}) : key => pla }

        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = try(var.storage.blob_properties, null) != null ? [1] : []

    content {
      last_access_time_enabled      = try(var.storage.blob_properties.last_access_time_enabled, false)
      versioning_enabled            = try(var.storage.blob_properties.versioning_enabled, false)
      change_feed_enabled           = try(var.storage.blob_properties.change_feed_enabled, false)
      change_feed_retention_in_days = try(var.storage.blob_properties.change_feed_retention_in_days, null)
      default_service_version       = try(var.storage.blob_properties.default_service_version, null)

      dynamic "cors_rule" {
        for_each = lookup(var.storage.blob_properties, "cors_rules", {})

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = try(var.storage.blob_properties.delete_retention_policy != null ? [var.storage.blob_properties.delete_retention_policy] : [], [])

        content {
          days                     = try(delete_retention_policy.value.days, 7)
          permanent_delete_enabled = try(delete_retention_policy.value.permanent_delete_enabled, null)
        }
      }

      dynamic "restore_policy" {
        for_each = try(var.storage.blob_properties.restore_policy != null ? [var.storage.blob_properties.restore_policy] : [], [])

        content {
          days = try(var.storage.blob_properties.restore_policy.days, 7)
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(var.storage.blob_properties.container_delete_retention_policy != null ? [var.storage.blob_properties.container_delete_retention_policy] : [], [])

        content {
          days = try(var.storage.blob_properties.container_delete_retention_policy.days, 7)
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = try(var.storage.share_properties, null) != null ? [1] : []
    content {

      dynamic "cors_rule" {
        for_each = lookup(var.storage.share_properties, "cors_rules", {})

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = try(var.storage.share_properties.retention_policy != null ? [var.storage.share_properties.retention_policy] : [], [])

        content {
          days = try(var.storage.share_properties.retention_policy.days, 7)
        }
      }

      dynamic "smb" {
        for_each = try(var.storage.share_properties.smb != null ? [var.storage.share_properties.smb] : [], [])

        content {
          versions                        = try(var.storage.share_properties.smb.versions, [])
          authentication_types            = try(var.storage.share_properties.smb.authentication_types, [])
          channel_encryption_type         = try(var.storage.share_properties.smb.channel_encryption_type, [])
          multichannel_enabled            = try(var.storage.share_properties.smb.multichannel_enabled, false)
          kerberos_ticket_encryption_type = try(var.storage.share_properties.smb.kerberos_ticket_encryption_type, [])
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = try(var.storage.share_properties.azure_files_authentication, null) != null ? { auth = var.storage.share_properties.azure_files_authentication } : {}

    content {
      directory_type                 = try(azure_files_authentication.value.directory_type, "AD")
      default_share_level_permission = try(azure_files_authentication.value.default_share_level_permission, null)

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.directory_type == "AD" ? [azure_files_authentication.value.active_directory] : []

        content {
          domain_name         = active_directory.value.domain_name
          domain_guid         = active_directory.value.domain_guid
          forest_name         = try(active_directory.value.forest_name, null)
          domain_sid          = try(active_directory.value.domain_sid, null)
          storage_sid         = try(active_directory.value.storage_sid, null)
          netbios_domain_name = try(active_directory.value.netbios_domain_name, null)
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = try(var.storage.queue_properties, null) != null ? [1] : []
    content {

      dynamic "cors_rule" {
        for_each = lookup(var.storage.queue_properties, "cors_rules", {})

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = try(var.storage.queue_properties.logging != null ? [var.storage.queue_properties.logging] : [], [])

        content {
          version               = try(var.storage.queue_properties.logging.version, "1.0")
          delete                = try(var.storage.queue_properties.logging.delete, false)
          read                  = try(var.storage.queue_properties.logging.read, false)
          write                 = try(var.storage.queue_properties.logging.write, false)
          retention_policy_days = try(var.storage.queue_properties.logging.retention_policy_days, 7)
        }
      }

      dynamic "minute_metrics" {
        for_each = try(var.storage.queue_properties.minute_metrics != null ? [var.storage.queue_properties.minute_metrics] : [], [])

        content {
          enabled               = try(var.storage.queue_properties.minute_metrics.enabled, false)
          version               = try(var.storage.queue_properties.minute_metrics.version, "1.0")
          include_apis          = try(var.storage.queue_properties.minute_metrics.include_apis, false)
          retention_policy_days = try(var.storage.queue_properties.minute_metrics.retention_policy_days, 7)
        }
      }

      dynamic "hour_metrics" {
        for_each = try(var.storage.queue_properties.hour_metrics != null ? [var.storage.queue_properties.hour_metrics] : [], [])

        content {
          enabled               = try(var.storage.queue_properties.hour_metrics.enabled, false)
          version               = try(var.storage.queue_properties.hour_metrics.version, "1.0")
          include_apis          = try(var.storage.queue_properties.hour_metrics.include_apis, false)
          retention_policy_days = try(var.storage.queue_properties.hour_metrics.retention_policy_days, 7)
        }
      }
    }
  }

  dynamic "sas_policy" {
    for_each = try(var.storage.policy.sas, null) != null ? { "default" = var.storage.policy.sas } : {}

    content {
      expiration_action = sas_policy.value.expiration_action
      expiration_period = sas_policy.value.expiration_period
    }
  }

  dynamic "routing" {
    for_each = try(var.storage.routing, null) != null ? { "default" = var.storage.routing } : {}

    content {
      choice                      = try(routing.value.choice, "MicrosoftRouting")
      publish_internet_endpoints  = try(routing.value.publish_internet_endpoints, false)
      publish_microsoft_endpoints = try(routing.value.publish_microsoft_endpoints, false)
    }
  }

  dynamic "immutability_policy" {
    for_each = try(var.storage.policy.immutability, null) != null ? { "default" = var.storage.policy.immutability } : {}

    content {
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
    }
  }

  dynamic "custom_domain" {
    for_each = try(var.storage.custom_domain, null) != null ? { "default" = var.storage.custom_domain } : {}

    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = lookup(var.storage, "customer_managed_key", null) != null ? { "default" = var.storage.customer_managed_key } : {}

    content {
      key_vault_key_id          = try(customer_managed_key.value.key_vault_key_id, null)
      managed_hsm_key_id        = try(customer_managed_key.value.managed_hsm_key_id, null)
      user_assigned_identity_id = azurerm_user_assigned_identity.identity["identity"].id
    }
  }

  dynamic "static_website" {
    for_each = try(var.storage.static_website, null) != null ? [1] : []

    content {
      index_document     = try(static_website.value.index_document, null)
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }

  dynamic "identity" {
    for_each = lookup(var.storage, "identity", null) != null ? [var.storage.identity] : []
    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

# containers
resource "azurerm_storage_container" "sc" {
  for_each = lookup(
  lookup(var.storage, "blob_properties", {}), "containers", {})

  name                  = try(each.value.name, join("-", [var.naming.storage_container, each.key]))
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = try(each.value.access_type, "private")
  metadata              = try(each.value.metadata, {})
}

# queues
resource "azurerm_storage_queue" "sq" {
  for_each = try(
    var.storage.queue_properties.queues, {}
  )

  name                 = try(each.value.name, join("-", [var.naming.storage_queue, each.key]))
  storage_account_name = azurerm_storage_account.sa.name
  metadata             = try(each.value.metadata, {})
}


resource "azurerm_storage_account_local_user" "lu" {
  for_each = merge({
    for kv in flatten([
      for container_name, container_def in lookup(lookup(var.storage, "blob_properties", {}), "containers", {}) : [
        for user_key, user_def in lookup(container_def, "local_users", {}) : {
          key = "${container_name}-${user_key}"
          value = {
            service          = "blob" # currently only blob and file is supported
            resource_name    = azurerm_storage_container.sc[container_name].name
            name             = try(user_def.name, user_key)
            home_directory   = try(user_def.home_directory, null)
            ssh_key_enabled  = try(user_def.ssh_key_enabled, false)
            ssh_pass_enabled = try(user_def.ssh_password_enabled, false)

            ssh_authorized_keys = try(
              user_def.ssh_authorized_keys, {}
            )

            permissions = try(
              user_def.permission_scope.permissions, {}
            )
          }
        }
      ]
    ]) : kv.key => kv.value
    },
    {
      for kv in flatten([
        for share_name, share_def in lookup(lookup(var.storage, "share_properties", {}), "shares", {}) : [
          for user_key, user_def in lookup(share_def, "local_users", {}) : {
            key = "${share_name}-${user_key}"
            value = {
              service          = "file"
              resource_name    = azurerm_storage_share.sh[share_name].name
              name             = try(user_def.name, user_key)
              home_directory   = try(user_def.home_directory, null)
              ssh_key_enabled  = try(user_def.ssh_key_enabled, false)
              ssh_pass_enabled = try(user_def.ssh_password_enabled, false)

              ssh_authorized_keys = try(
                user_def.ssh_authorized_keys, {}
              )

              permissions = try(
                user_def.permission_scope.permissions, {}
              )
            }
          }
        ]
      ]) : kv.key => kv.value
    }
  )

  name                 = each.value.name
  ssh_key_enabled      = each.value.ssh_key_enabled
  ssh_password_enabled = each.value.ssh_pass_enabled
  home_directory       = each.value.home_directory
  storage_account_id   = azurerm_storage_account.sa.id

  dynamic "ssh_authorized_key" {
    for_each = try(
      each.value.ssh_authorized_keys, {}
    )

    content {
      description = try(ssh_authorized_key.value.description, null)
      key         = ssh_authorized_key.value.key
    }
  }

  permission_scope {
    service       = each.value.service
    resource_name = each.value.resource_name

    permissions {
      read   = try(each.value.permissions.read, false)
      write  = try(each.value.permissions.write, false)
      list   = try(each.value.permissions.list, false)
      create = try(each.value.permissions.create, false)
      delete = try(each.value.permissions.delete, false)
    }
  }
}

# shares
resource "azurerm_storage_share" "sh" {
  for_each = lookup(
  lookup(var.storage, "share_properties", {}), "shares", {})

  name               = try(each.value.name, join("-", [var.naming.storage_share, each.key]))
  storage_account_id = azurerm_storage_account.sa.id
  quota              = each.value.quota
  metadata           = try(each.value.metadata, {})
  access_tier        = try(each.value.access_tier, "Hot")
  enabled_protocol   = try(each.value.protocol, "SMB")

  dynamic "acl" {
    for_each = try(
      each.value.acl, {}
    )

    content {
      id = acl.key

      dynamic "access_policy" {
        for_each = can(acl.value.access_policy) ? [acl.value.access_policy] : []
        content {
          permissions = access_policy.value.permissions
          start       = try(access_policy.value.start, null)
          expiry      = try(access_policy.value.expiry, null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata["syncsignature"],
      metadata["SyncSignature"]
    ]
  }
}

# tables
resource "azurerm_storage_table" "st" {
  for_each = try(
    var.storage.tables, {}
  )

  name                 = try(each.value.name, join("-", [var.naming.storage_table, each.key]))
  storage_account_name = azurerm_storage_account.sa.name
}

# file systems
resource "azurerm_storage_data_lake_gen2_filesystem" "fs" {
  for_each = try(
    var.storage.file_systems, {}
  )
  name                     = try(each.value.name, join("-", [var.naming.storage_data_lake_gen2_filesystem, each.key]))
  storage_account_id       = azurerm_storage_account.sa.id
  properties               = try(each.value.properties, {})
  owner                    = try(each.value.owner, null)
  group                    = try(each.value.group, null)
  default_encryption_scope = try(each.value.default_encryption_scope, null)

  dynamic "ace" {
    for_each = try(each.value.ace, {})
    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = try(ace.value.scope, "access")
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "pa" {
  for_each = merge([
    for fs_key, fs in try(var.storage.file_systems, {}) : {
      for pa_key, pa in try(fs.paths, {}) : pa_key => {
        path               = try(pa.path, pa_key)
        filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fs[fs_key].name
        storage_account_id = azurerm_storage_account.sa.id
        owner              = try(pa.owner, null)
        group              = try(pa.group, null)
        ace                = try(pa.ace, {})
      }
    }
  ]...)

  path               = each.value.path
  filesystem_name    = each.value.filesystem_name
  storage_account_id = each.value.storage_account_id
  owner              = each.value.owner
  group              = each.value.group
  resource           = "directory" # currently only directory is supported

  dynamic "ace" {
    for_each = try(each.value.ace, {})
    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = try(ace.value.scope, "access")
    }
  }
}

# management policies
resource "azurerm_storage_management_policy" "mgmt_policy" {
  for_each = try(var.storage.management_policy, null) != null ? { "default" = var.storage.management_policy } : {}

  storage_account_id = azurerm_storage_account.sa.id

  dynamic "rule" {
    for_each = try(var.storage.management_policy.rules, {})

    content {
      name    = try(rule.value.name, rule.key)
      enabled = try(rule.value.enabled, true)

      dynamic "filters" {
        for_each = try(rule.value.filters, {})

        content {
          prefix_match = try(filters.value.prefix_match, null)
          blob_types   = try(filters.value.blob_types, null)

          dynamic "match_blob_index_tag" {
            for_each = try(filters.match_blob_index_tag, {})

            content {
              name      = try(match_blob_index_tag.value.name, null)
              operation = try(match_blob_index_tag.value.operation, null)
              value     = try(match_blob_index_tag.value.value, null)
            }
          }
        }

      }
      actions {
        dynamic "base_blob" {
          for_each = try(rule.value.actions.base_blob, {})

          # provider injects -1 in the plan, even when it is not specified in the config
          content {
            tier_to_cool_after_days_since_modification_greater_than        = try(base_blob.value.tier_to_cool_after_days_since_modification_greater_than, null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = try(base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than, null)
            tier_to_archive_after_days_since_modification_greater_than     = try(base_blob.value.tier_to_archive_after_days_since_modification_greater_than, null)
            tier_to_archive_after_days_since_last_access_time_greater_than = try(base_blob.value.tier_to_archive_after_days_since_last_access_time_greater_than, null)
            delete_after_days_since_modification_greater_than              = try(base_blob.value.delete_after_days_since_modification_greater_than, null)
            delete_after_days_since_last_access_time_greater_than          = try(base_blob.value.delete_after_days_since_last_access_time_greater_than, null)
            auto_tier_to_hot_from_cool_enabled                             = contains(keys(base_blob.value), "auto_tier_to_hot_from_cool_enabled") ? base_blob.value.auto_tier_to_hot_from_cool_enabled : null
            delete_after_days_since_creation_greater_than                  = try(base_blob.value.delete_after_days_since_creation_greater_than, null)
            tier_to_cold_after_days_since_creation_greater_than            = try(base_blob.value.tier_to_cold_after_days_since_creation_greater_than, null)
            tier_to_cool_after_days_since_creation_greater_than            = try(base_blob.value.tier_to_cool_after_days_since_creation_greater_than, null)
            tier_to_archive_after_days_since_creation_greater_than         = try(base_blob.value.tier_to_archive_after_days_since_creation_greater_than, null)
            tier_to_cold_after_days_since_modification_greater_than        = try(base_blob.value.tier_to_cold_after_days_since_modification_greater_than, null)
            tier_to_cold_after_days_since_last_access_time_greater_than    = try(base_blob.value.tier_to_cold_after_days_since_last_access_time_greater_than, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = try(base_blob.value.tier_to_archive_after_days_since_last_tier_change_greater_than, null)
          }
        }

        dynamic "snapshot" {
          for_each = try(rule.value.actions.snapshot, {})

          content {
            change_tier_to_archive_after_days_since_creation               = try(snapshot.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation                  = try(snapshot.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation_greater_than                  = try(snapshot.value.delete_after_days_since_creation_greater_than, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = try(snapshot.value.tier_to_archive_after_days_since_last_tier_change_greater_than, null)
            tier_to_cold_after_days_since_creation_greater_than            = try(snapshot.value.tier_to_cold_after_days_since_creation_greater_than, null)
          }
        }

        dynamic "version" {
          for_each = try(rule.value.actions.version, {})

          content {
            change_tier_to_archive_after_days_since_creation               = try(version.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation                  = try(version.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation                               = try(version.value.delete_after_days_since_creation, null)
            tier_to_cold_after_days_since_creation_greater_than            = try(version.value.tier_to_cold_after_days_since_creation_greater_than, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = try(version.value.tier_to_archive_after_days_since_last_tier_change_greater_than, null)
          }
        }
      }
    }
  }
  depends_on = [azurerm_storage_container.sc]
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = lookup(var.storage, "identity", null) != null ? (
    (lookup(var.storage.identity, "type", null) == "UserAssigned" ||
    lookup(var.storage.identity, "type", null) == "SystemAssigned, UserAssigned") &&
    lookup(var.storage.identity, "identity_ids", null) == null ? { "identity" = var.storage.identity } : {}
  ) : {}

  name                = try(each.value.name, "uai-${var.storage.name}")
  resource_group_name = var.storage.resource_group
  location            = var.storage.location
  tags                = try(each.value.tags, var.tags, null)
}

resource "azurerm_role_assignment" "managed_identity" {
  for_each = lookup(var.storage, "customer_managed_key", null) != null ? { "identity" = var.storage.customer_managed_key } : {}

  scope                = each.value.key_vault_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.identity["identity"].principal_id
}

# advanced threat protection
resource "azurerm_advanced_threat_protection" "prot" {
  for_each = try(var.storage.threat_protection, false) ? { "threat_protection" = true } : {}

  target_resource_id = azurerm_storage_account.sa.id
  enabled            = true
}
