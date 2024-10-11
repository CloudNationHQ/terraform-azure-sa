data "azurerm_subscription" "current" {}

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
  nfsv3_enabled                     = try(var.storage.nfsv3_enabled, false)
  cross_tenant_replication_enabled  = try(var.storage.cross_tenant_replication_enabled, false)
  default_to_oauth_authentication   = try(var.storage.default_to_oauth_authentication, false)
  tags                              = try(var.storage.tags, var.tags, null)

  sftp_enabled = (
    try(var.storage.enable.is_hns, false) == false ?
    try(var.storage.enable.sftp, false)
    : true
  )

  dynamic "network_rules" {
    for_each = try(var.storage.network_rules, null) != null ? { "default" = var.storage.network_rules } : {}

    content {
      bypass                     = try(network_rules.value.bypass, ["None"])
      default_action             = try(network_rules.value.default_action, "Deny")
      ip_rules                   = try(network_rules.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, null)
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
          days = try(var.storage.blob_properties.delete_retention_policy.days, 7)
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
    for_each = try(var.storage.share_properties.authentication, null) != null ? { auth = var.storage.share_properties.authentication } : {}

    content {
      directory_type = try(azure_files_authentication.value.type, "AD")

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.type == "AD" ? [azure_files_authentication.value.active_directory] : []

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
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = azurerm_user_assigned_identity.identity["identity"].id
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

# queues
resource "azurerm_storage_queue" "sq" {
  for_each = {
    for sq in local.queues : sq.sq_key => sq
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
  metadata             = each.value.metadata
}

# shares
resource "azurerm_storage_share" "sh" {
  for_each = {
    for fs in local.shares : fs.fs_key => fs
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
  quota                = each.value.quota
  metadata             = each.value.metadata
  access_tier          = each.value.access_tier
  enabled_protocol     = each.value.enabled_protocol

  dynamic "acl" {
    for_each = try(each.value.acl, {}) != {} ? each.value.acl : {}
    content {
      id = try(acl.value.id, acl.key)
      dynamic "access_policy" {
        for_each = try(acl.value.access_policy, null) != null ? { default : acl.value.access_policy } : {}
        content {
          permissions = try(access_policy.value.permissions, null)
          start       = try(access_policy.value.start, null)
          expiry      = try(access_policy.value.expiry, null)
        }
      }
    }
  }
}

# tables
resource "azurerm_storage_table" "st" {
  for_each = {
    for st in local.tables : st.st_key => st
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
}

# file systems
resource "azurerm_storage_data_lake_gen2_filesystem" "fs" {
  for_each = {
    for fs in local.file_systems : fs.fs_key => fs
  }

  name                     = each.value.name
  storage_account_id       = each.value.storage_account_id
  default_encryption_scope = each.value.default_encryption_scope
  properties               = each.value.properties
  owner                    = each.value.owner
  group                    = each.value.group

  dynamic "ace" {
    for_each = try(each.value.ace, {}) != {} ? each.value.ace : {}
    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = try(ace.value.scope, "access")
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "pa" {
  for_each = {
    for pa in local.fs_paths : pa.pa_key => pa
  }

  path               = each.value.path
  filesystem_name    = each.value.filesystem_name
  storage_account_id = each.value.storage_account_id
  owner              = each.value.owner
  group              = each.value.group
  resource           = "directory" ## Currently only directory is supported

  dynamic "ace" {
    for_each = try(each.value.ace, {}) != {} ? each.value.ace : {}
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
  for_each = try(var.storage.mgt_policy, null) != null ? { "default" = var.storage.mgt_policy } : {}

  storage_account_id = azurerm_storage_account.sa.id

  dynamic "rule" {
    for_each = try(var.storage.mgt_policy.rules, {})

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

          content {
            tier_to_cool_after_days_since_modification_greater_than        = try(base_blob.value.tier_to_cool_after_days_since_modification_greater_than, null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = try(base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than, null)
            tier_to_archive_after_days_since_modification_greater_than     = try(base_blob.value.tier_to_archive_after_days_since_modification_greater_than, null)
            tier_to_archive_after_days_since_last_access_time_greater_than = try(base_blob.value.tier_to_archive_after_days_since_last_access_time_greater_than, null)
            delete_after_days_since_modification_greater_than              = try(base_blob.value.delete_after_days_since_modification_greater_than, null)
            delete_after_days_since_last_access_time_greater_than          = try(base_blob.value.delete_after_days_since_last_access_time_greater_than, null)
            auto_tier_to_hot_from_cool_enabled                             = try(base_blob.value.auto_tier_to_hot_from_cool_enabled, false)
          }
        }

        dynamic "snapshot" {
          for_each = try(rule.value.actions.snapshot, {})

          content {
            change_tier_to_archive_after_days_since_creation = try(snapshot.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation    = try(snapshot.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation_greater_than    = try(snapshot.value.delete_after_days_since_creation_greater_than, null)
          }
        }

        dynamic "version" {
          for_each = try(rule.value.actions.version, {})

          content {
            change_tier_to_archive_after_days_since_creation = try(version.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation    = try(version.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation                 = try(version.value.delete_after_days_since_creation, null)
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
