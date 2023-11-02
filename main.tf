data "azurerm_subscription" "current" {}

# storage accounts
resource "azurerm_storage_account" "sa" {
  name                     = var.storage.name
  resource_group_name      = var.storage.resourcegroup
  location                 = var.storage.location
  account_tier             = try(var.storage.sku.tier, "Standard")
  account_replication_type = try(var.storage.sku.type, "GRS")
  account_kind             = try(var.storage.kind, "StorageV2")

  allow_nested_items_to_be_public  = try(var.storage.enable.allow_public_nested_items, true)
  shared_access_key_enabled        = try(var.storage.enable.shared_access_key, true)
  public_network_access_enabled    = try(var.storage.enable.public_network_access, false)
  is_hns_enabled                   = try(var.storage.enable.is_hns, false)
  nfsv3_enabled                    = try(var.storage.enable.nfsv3, false)
  cross_tenant_replication_enabled = try(var.storage.enable.cross_tenant_replication, true)
  default_to_oauth_authentication  = try(var.storage.enable.default_to_oauth_authentication, false)

  sftp_enabled = (
    try(var.storage.enable.is_hns, false) == false ?
    try(var.storage.enable.sftp, false)
    : true
  )

  blob_properties {
    last_access_time_enabled      = try(var.storage.blob_properties.last_access_time, false)
    versioning_enabled            = try(var.storage.blob_properties.versioning, false)
    change_feed_enabled           = try(var.storage.blob_properties.change_feed, false)
    change_feed_retention_in_days = try(var.storage.blob_properties.change_feed_retention_in_days, null)
    default_service_version       = try(var.storage.blob_properties.default_service_version, "2020-06-12")

    dynamic "cors_rule" {
      for_each = {
        for k, v in try(var.storage.blob_properties.cors_rules, {}) : k => v
      }

      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }

    delete_retention_policy {
      days = try(var.storage.blob_properties.delete_retention_in_days, 7)
    }

    dynamic "restore_policy" {
      for_each = try(var.storage.blob_properties.restore_policy, false) == true ? [1] : []

      content {
        days = try(var.storage.blob_properties.restore_in_days, 5)
      }
    }

    container_delete_retention_policy {
      days = try(var.storage.blob_properties.container_delete_retention_in_days, 7)
    }
  }

  share_properties {
    dynamic "cors_rule" {
      for_each = {
        for k, v in try(var.storage.share_properties.cors_rules, {}) : k => v
      }

      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }

    retention_policy {
      days = try(var.storage.share_properties.retention_in_days, 7)
    }

    dynamic "smb" {
      for_each = try(var.storage.share_properties.smb, null) != null ? [1] : []

      content {
        versions                        = try(var.storage.share_properties.smb.versions, [])
        authentication_types            = try(var.storage.share_properties.smb.authentication_types, [])
        channel_encryption_type         = try(var.storage.share_properties.smb.channel_encryption_type, [])
        multichannel_enabled            = try(var.storage.share_properties.smb.multichannel_enabled, false)
        kerberos_ticket_encryption_type = try(var.storage.share_properties.smb.kerb_ticket_encryption_type, [])
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

  queue_properties {
    dynamic "cors_rule" {
      for_each = {
        for k, v in try(var.storage.queue_properties.cors_rules, {}) : k => v
      }

      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }

    logging {
      version               = try(var.storage.queue_properties.logging.version, "1.0")
      delete                = try(var.storage.queue_properties.logging.delete, false)
      read                  = try(var.storage.queue_properties.logging.read, false)
      write                 = try(var.storage.queue_properties.logging.write, false)
      retention_policy_days = try(var.storage.queue_properties.logging.retention_in_days, 7)
    }

    minute_metrics {
      enabled               = try(var.storage.queue_properties.minute_metrics.enabled, false)
      version               = try(var.storage.queue_properties.minute_metrics.version, "1.0")
      include_apis          = try(var.storage.queue_properties.minute_metrics.include_apis, false)
      retention_policy_days = try(var.storage.queue_properties.minute_metrics.retention_policy_days, 7)
    }

    hour_metrics {
      enabled               = try(var.storage.queue_properties.hour_metrics.enable, false)
      version               = try(var.storage.queue_properties.hour_metrics.version, "1.0")
      include_apis          = try(var.storage.queue_properties.hour_metrics.include_apis, false)
      retention_policy_days = try(var.storage.queue_properties.hour_metrics.retention_policy_days, 7)
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
      state                         = immutability_policy.value.state_mode
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

  identity {
    type = "SystemAssigned"
  }
}

# containers
resource "azurerm_storage_container" "sc" {
  for_each = {
    for sc in local.containers : sc.sc_key => sc
  }

  name                  = each.value.name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}

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
}

# tables
resource "azurerm_storage_table" "st" {
  for_each = {
    for st in local.tables : st.st_key => st
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
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
}

# advanced threat protection
resource "azurerm_advanced_threat_protection" "prot" {
  for_each = try(var.storage.threat_protection, false) ? { "threat_protection" = true } : {}

  target_resource_id = azurerm_storage_account.sa.id
  enabled            = true
}

# private endpoint
resource "azurerm_private_endpoint" "endpoint" {
  for_each = contains(keys(var.storage), "private_endpoint") ? { "default" = var.storage.private_endpoint } : {}

  name                = var.storage.private_endpoint.name
  location            = var.storage.location
  resource_group_name = var.storage.resourcegroup
  subnet_id           = var.storage.private_endpoint.subnet

  private_service_connection {
    name                           = "endpoint"
    is_manual_connection           = try(each.value.is_manual_connection, false)
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = each.value.subresources
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.storage.private_endpoint.dns_zones
  }
}
