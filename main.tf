# storage accounts
resource "azurerm_storage_account" "sa" {

  resource_group_name = coalesce(
    lookup(
      var.storage, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.storage, "location", null
    ), var.location
  )

  name                              = var.storage.name
  account_tier                      = var.storage.account_tier
  account_replication_type          = var.storage.account_replication_type
  account_kind                      = var.storage.account_kind
  access_tier                       = var.storage.access_tier
  infrastructure_encryption_enabled = var.storage.infrastructure_encryption_enabled
  https_traffic_only_enabled        = var.storage.https_traffic_only_enabled
  min_tls_version                   = var.storage.min_tls_version
  edge_zone                         = var.storage.edge_zone
  table_encryption_key_type         = var.storage.table_encryption_key_type
  queue_encryption_key_type         = var.storage.queue_encryption_key_type
  allowed_copy_scope                = var.storage.allowed_copy_scope
  large_file_share_enabled          = var.storage.large_file_share_enabled
  allow_nested_items_to_be_public   = var.storage.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.storage.shared_access_key_enabled
  public_network_access_enabled     = var.storage.public_network_access_enabled
  is_hns_enabled                    = var.storage.is_hns_enabled
  sftp_enabled                      = var.storage.sftp_enabled
  nfsv3_enabled                     = var.storage.nfsv3_enabled
  cross_tenant_replication_enabled  = var.storage.cross_tenant_replication_enabled
  local_user_enabled                = var.storage.local_user_enabled
  dns_endpoint_type                 = var.storage.dns_endpoint_type
  default_to_oauth_authentication   = var.storage.default_to_oauth_authentication

  tags = try(
    var.storage.tags, var.tags, null
  )

  dynamic "network_rules" {
    for_each = try(var.storage.network_rules, null) != null ? [var.storage.network_rules] : []

    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = { for key, pla in try(var.storage.network_rules.private_link_access, {}) : key => pla }

        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = try(var.storage.blob_properties, null) != null ? [1] : []

    content {
      last_access_time_enabled      = var.storage.blob_properties.last_access_time_enabled
      versioning_enabled            = var.storage.blob_properties.versioning_enabled
      change_feed_enabled           = var.storage.blob_properties.change_feed_enabled
      change_feed_retention_in_days = var.storage.blob_properties.change_feed_retention_in_days
      default_service_version       = var.storage.blob_properties.default_service_version

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
          days                     = delete_retention_policy.value.days
          permanent_delete_enabled = delete_retention_policy.value.permanent_delete_enabled
        }
      }

      dynamic "restore_policy" {
        for_each = try(var.storage.blob_properties.restore_policy != null ? [var.storage.blob_properties.restore_policy] : [], [])

        content {
          days = var.storage.blob_properties.restore_policy.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(var.storage.blob_properties.container_delete_retention_policy != null ? [var.storage.blob_properties.container_delete_retention_policy] : [], [])

        content {
          days = var.storage.blob_properties.container_delete_retention_policy.days
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
          days = var.storage.share_properties.retention_policy.days
        }
      }

      dynamic "smb" {
        for_each = try(var.storage.share_properties.smb != null ? [var.storage.share_properties.smb] : [], [])

        content {
          versions                        = var.storage.share_properties.smb.versions
          authentication_types            = var.storage.share_properties.smb.authentication_types
          channel_encryption_type         = var.storage.share_properties.smb.channel_encryption_type
          multichannel_enabled            = var.storage.share_properties.smb.multichannel_enabled
          kerberos_ticket_encryption_type = var.storage.share_properties.smb.kerberos_ticket_encryption_type
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = try(var.storage.share_properties.azure_files_authentication, null) != null ? { auth = var.storage.share_properties.azure_files_authentication } : {}

    content {
      directory_type                 = azure_files_authentication.value.directory_type
      default_share_level_permission = azure_files_authentication.value.default_share_level_permission

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.directory_type == "AD" ? [azure_files_authentication.value.active_directory] : []

        content {
          domain_name         = active_directory.value.domain_name
          domain_guid         = active_directory.value.domain_guid
          forest_name         = active_directory.value.forest_name
          domain_sid          = active_directory.value.domain_sid
          storage_sid         = active_directory.value.storage_sid
          netbios_domain_name = active_directory.value.netbios_domain_name
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
          version               = var.storage.queue_properties.logging.version
          delete                = var.storage.queue_properties.logging.delete
          read                  = var.storage.queue_properties.logging.read
          write                 = var.storage.queue_properties.logging.write
          retention_policy_days = var.storage.queue_properties.logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = try(var.storage.queue_properties.minute_metrics != null ? [var.storage.queue_properties.minute_metrics] : [], [])

        content {
          enabled               = var.storage.queue_properties.minute_metrics.enabled
          version               = var.storage.queue_properties.minute_metrics.version
          include_apis          = var.storage.queue_properties.minute_metrics.include_apis
          retention_policy_days = var.storage.queue_properties.minute_metrics.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = try(var.storage.queue_properties.hour_metrics != null ? [var.storage.queue_properties.hour_metrics] : [], [])

        content {
          enabled               = var.storage.queue_properties.hour_metrics.enabled
          version               = var.storage.queue_properties.hour_metrics.version
          include_apis          = var.storage.queue_properties.hour_metrics.include_apis
          retention_policy_days = var.storage.queue_properties.hour_metrics.retention_policy_days
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
      choice                      = routing.value.choice
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
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
      managed_hsm_key_id        = customer_managed_key.value.managed_hsm_key_id
      user_assigned_identity_id = azurerm_user_assigned_identity.identity["identity"].id
    }
  }

  dynamic "static_website" {
    for_each = try(var.storage.static_website, null) != null ? [1] : []

    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
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
  for_each = nonsensitive(coalesce(
    var.storage.blob_properties != null ? var.storage.blob_properties.containers : {},
    {}
  ))

  name = coalesce(
    var.storage.blob_properties.containers[each.key].name,
    join("-", [var.naming.storage_container, each.key])
  )
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = var.storage.blob_properties.containers[each.key].access_type
  metadata              = var.storage.blob_properties.containers[each.key].metadata
}

# queues
resource "azurerm_storage_queue" "sq" {
  for_each = nonsensitive(coalesce(
    var.storage.queue_properties != null ? var.storage.queue_properties.queues : {},
    {}
  ))

  name = coalesce(
    each.value.name, join("-", [var.naming.storage_queue, each.key])
  )

  storage_account_name = azurerm_storage_account.sa.name
  metadata             = each.value.metadata
}

resource "azurerm_storage_account_local_user" "lu" {
  for_each = nonsensitive(merge(
    var.storage != null && var.storage.blob_properties != null ? {
      for kv in flatten([
        for container_name, container_def in lookup(var.storage.blob_properties, "containers", {}) : [
          for user_key, user_def in lookup(container_def, "local_users", {}) : {
            key = "${container_name}-${user_key}"
            value = {
              service             = "blob"
              resource_name       = azurerm_storage_container.sc[container_name].name
              home_directory      = user_def.home_directory
              ssh_key_enabled     = user_def.ssh_key_enabled
              ssh_pass_enabled    = user_def.ssh_password_enabled
              ssh_authorized_keys = user_def.ssh_authorized_keys
              permissions         = user_def.permission_scope.permissions
              name = coalesce(
                lookup(
                  user_def, "name", null
                ), user_key
              )
            }
          }
        ]
      ]) : kv.key => kv.value
    } : {},
    var.storage != null && var.storage.share_properties != null ? {
      for kv in flatten([
        for share_name, share_def in lookup(var.storage.share_properties, "shares", {}) : [
          for user_key, user_def in lookup(share_def, "local_users", {}) : {
            key = "${share_name}-${user_key}"
            value = {
              service             = "file"
              resource_name       = azurerm_storage_share.sh[share_name].name
              home_directory      = user_def.home_directory
              ssh_key_enabled     = user_def.ssh_key_enabled
              ssh_pass_enabled    = user_def.ssh_password_enabled
              ssh_authorized_keys = user_def.ssh_authorized_keys
              permissions         = user_def.permission_scope.permissions
              name = coalesce(
                lookup(
                  user_def, "name", null
                ), user_key
              )
            }
          }
        ]
      ]) : kv.key => kv.value
    } : {}
  ))

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
      description = ssh_authorized_key.value.description
      key         = ssh_authorized_key.value.key
    }
  }

  permission_scope {
    service       = each.value.service
    resource_name = each.value.resource_name
    permissions {
      read   = each.value.permissions.read
      write  = each.value.permissions.write
      list   = each.value.permissions.list
      create = each.value.permissions.create
      delete = each.value.permissions.delete
    }
  }
}

# shares
resource "azurerm_storage_share" "sh" {
  for_each = coalesce(
    var.storage.share_properties != null ? var.storage.share_properties.shares : {},
    {}
  )

  name = coalesce(
    each.value.name,
    join("-", [var.naming.storage_share, each.key])
  )

  storage_account_id = azurerm_storage_account.sa.id
  quota              = each.value.quota
  metadata           = each.value.metadata
  access_tier        = each.value.access_tier
  enabled_protocol   = each.value.protocol

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
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
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
  for_each = coalesce(
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

  name = coalesce(
    each.value.name, join("-", [var.naming.storage_data_lake_gen2_filesystem, each.key])
  )

  storage_account_id       = azurerm_storage_account.sa.id
  properties               = each.value.properties
  owner                    = each.value.owner
  group                    = each.value.group
  default_encryption_scope = each.value.default_encryption_scope

  dynamic "ace" {
    for_each = try(each.value.ace, {})
    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = ace.value.scope
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "pa" {
  for_each = merge([
    for fs_key, fs in try(var.storage.file_systems, {}) : {
      for pa_key, pa in try(fs.paths, {}) : pa_key => {
        filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fs[fs_key].name
        storage_account_id = azurerm_storage_account.sa.id
        owner              = pa.owner
        group              = pa.group
        ace                = pa.ace
        path = coalesce(
          pa.path, pa_key
        )
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
      scope       = ace.value.scope
    }
  }
}

# management policies
resource "azurerm_storage_management_policy" "mgmt_policy" {
  for_each = try(var.storage.management_policy, null) != null ? { "default" = var.storage.management_policy } : {}

  storage_account_id = azurerm_storage_account.sa.id

  dynamic "rule" {
    for_each = lookup(
      each.value, "rules", {}
    )

    content {
      name    = rule.key
      enabled = rule.value.enabled

      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types
      }

      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than        = rule.value.actions.base_blob.tier_to_cool_after_days_since_modification_greater_than
          tier_to_cool_after_days_since_last_access_time_greater_than    = rule.value.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than
          tier_to_archive_after_days_since_modification_greater_than     = rule.value.actions.base_blob.tier_to_archive_after_days_since_modification_greater_than
          tier_to_archive_after_days_since_last_access_time_greater_than = rule.value.actions.base_blob.tier_to_archive_after_days_since_last_access_time_greater_than
          delete_after_days_since_modification_greater_than              = rule.value.actions.base_blob.delete_after_days_since_modification_greater_than
          delete_after_days_since_last_access_time_greater_than          = rule.value.actions.base_blob.delete_after_days_since_last_access_time_greater_than
          auto_tier_to_hot_from_cool_enabled                             = rule.value.actions.base_blob.auto_tier_to_hot_from_cool_enabled
          delete_after_days_since_creation_greater_than                  = rule.value.actions.base_blob.delete_after_days_since_creation_greater_than
          tier_to_archive_after_days_since_creation_greater_than         = rule.value.actions.base_blob.tier_to_archive_after_days_since_creation_greater_than
          tier_to_cool_after_days_since_creation_greater_than            = rule.value.actions.base_blob.tier_to_cool_after_days_since_creation_greater_than
          tier_to_cold_after_days_since_creation_greater_than            = rule.value.actions.base_blob.tier_to_cold_after_days_since_creation_greater_than
          tier_to_cold_after_days_since_modification_greater_than        = rule.value.actions.base_blob.tier_to_cold_after_days_since_modification_greater_than
          tier_to_cold_after_days_since_last_access_time_greater_than    = rule.value.actions.base_blob.tier_to_cold_after_days_since_last_access_time_greater_than
          tier_to_archive_after_days_since_last_tier_change_greater_than = rule.value.actions.base_blob.tier_to_archive_after_days_since_last_tier_change_greater_than
        }

        dynamic "snapshot" {
          for_each = lookup(rule.value.actions, "snapshot", null) != null ? (
            anytrue([
              for k, v in lookup(rule.value.actions, "snapshot", {}) :
              v != null && v != ""
            ]) ? ["snapshot"] : []
          ) : []

          content {
            change_tier_to_archive_after_days_since_creation               = rule.value.actions.snapshot.change_tier_to_archive_after_days_since_creation
            change_tier_to_cool_after_days_since_creation                  = rule.value.actions.snapshot.change_tier_to_cool_after_days_since_creation
            delete_after_days_since_creation_greater_than                  = rule.value.actions.snapshot.delete_after_days_since_creation_greater_than
            tier_to_archive_after_days_since_last_tier_change_greater_than = rule.value.actions.snapshot.tier_to_archive_after_days_since_last_tier_change_greater_than
            tier_to_cold_after_days_since_creation_greater_than            = rule.value.actions.snapshot.tier_to_cold_after_days_since_creation_greater_than
          }
        }

        dynamic "version" {
          for_each = lookup(rule.value.actions, "version", null) != null ? (
            anytrue([
              for k, v in lookup(rule.value.actions, "version", {}) :
              v != null && v != ""
            ]) ? ["version"] : []
          ) : []

          content {
            change_tier_to_archive_after_days_since_creation               = rule.value.actions.version.change_tier_to_archive_after_days_since_creation
            change_tier_to_cool_after_days_since_creation                  = rule.value.actions.version.change_tier_to_cool_after_days_since_creation
            delete_after_days_since_creation                               = rule.value.actions.version.delete_after_days_since_creation
            tier_to_cold_after_days_since_creation_greater_than            = rule.value.actions.version.tier_to_cold_after_days_since_creation_greater_than
            tier_to_archive_after_days_since_last_tier_change_greater_than = rule.value.actions.version.tier_to_archive_after_days_since_last_tier_change_greater_than
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
