# storage accounts
resource "azurerm_storage_account" "this" {
  resource_group_name = coalesce(
    var.storage.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.storage.location, var.location
  )

  name                              = var.storage.name
  account_tier                      = var.storage.account_tier
  account_replication_type          = var.storage.account_replication_type
  account_kind                      = var.storage.account_kind
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
  provisioned_billing_model_version = var.storage.provisioned_billing_model_version

  access_tier = contains(["BlockBlobStorage", "FileStorage"], var.storage.account_kind) ? null : coalesce(
    var.storage.access_tier, "Hot"
  )

  tags = coalesce(
    var.storage.tags, var.tags
  )

  dynamic "network_rules" {
    for_each = var.storage.network_rules != null ? { "this" = var.storage.network_rules } : {}

    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = { for key, pla in lookup(network_rules.value, "private_link_access", {}) : key => pla }

        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = var.storage.blob_properties != null ? { "this" = var.storage.blob_properties } : {}

    content {
      last_access_time_enabled      = blob_properties.value.last_access_time_enabled
      versioning_enabled            = blob_properties.value.versioning_enabled
      change_feed_enabled           = blob_properties.value.change_feed_enabled
      change_feed_retention_in_days = blob_properties.value.change_feed_retention_in_days
      default_service_version       = blob_properties.value.default_service_version

      dynamic "cors_rule" {
        for_each = lookup(
          blob_properties.value, "cors_rules", {}
        )

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.storage.blob_properties.delete_retention_policy != null ? { "this" = var.storage.blob_properties.delete_retention_policy } : {}

        content {
          days                     = delete_retention_policy.value.days
          permanent_delete_enabled = delete_retention_policy.value.permanent_delete_enabled
        }
      }

      dynamic "restore_policy" {
        for_each = var.storage.blob_properties.restore_policy != null ? { "this" = var.storage.blob_properties.restore_policy } : {}

        content {
          days = restore_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.storage.blob_properties.container_delete_retention_policy != null ? { "this" = var.storage.blob_properties.container_delete_retention_policy } : {}

        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.storage.share_properties != null ? { "this" = var.storage.share_properties } : {}

    content {
      dynamic "cors_rule" {
        for_each = lookup(
          share_properties.value, "cors_rules", {}
        )

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = share_properties.value.retention_policy != null ? { "this" = share_properties.value.retention_policy } : {}

        content {
          days = retention_policy.value.days
        }
      }

      dynamic "smb" {
        for_each = share_properties.value.smb != null ? { "this" = share_properties.value.smb } : {}

        content {
          versions                        = smb.value.versions
          authentication_types            = smb.value.authentication_types
          channel_encryption_type         = smb.value.channel_encryption_type
          multichannel_enabled            = smb.value.multichannel_enabled
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = try(var.storage.share_properties.azure_files_authentication, null) != null ? { "this" = var.storage.share_properties.azure_files_authentication } : {}

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

  dynamic "sas_policy" {
    for_each = var.storage.policy.sas != null ? { "this" = var.storage.policy.sas } : {}

    content {
      expiration_action = sas_policy.value.expiration_action
      expiration_period = sas_policy.value.expiration_period
    }
  }

  dynamic "routing" {
    for_each = var.storage.routing != null ? { "this" = var.storage.routing } : {}

    content {
      choice                      = routing.value.choice
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
    }
  }

  dynamic "immutability_policy" {
    for_each = var.storage.policy.immutability != null ? { "this" = var.storage.policy.immutability } : {}

    content {
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
    }
  }

  dynamic "custom_domain" {
    for_each = var.storage.custom_domain != null ? { "this" = var.storage.custom_domain } : {}

    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.storage.customer_managed_key != null ? { "this" = var.storage.customer_managed_key } : {}

    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  dynamic "static_website" {
    for_each = var.storage.static_website != null ? { "this" = var.storage.static_website } : {}

    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  dynamic "identity" {
    for_each = var.storage.identity != null ? { "this" = var.storage.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  lifecycle {
    ignore_changes = [queue_properties]
  }
  depends_on = [azurerm_role_assignment.this]
}

# private endpoints
resource "azurerm_private_endpoint" "this" {
  for_each = var.storage.private_endpoints != null ? var.storage.private_endpoints : {}

  name = coalesce(
    each.value.name, each.key
  )

  resource_group_name = coalesce(
    var.storage.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.storage.location, var.location
  )

  subnet_id                     = each.value.subnet_resource_id
  custom_network_interface_name = each.value.custom_network_interface_name

  tags = coalesce(
    each.value.tags, var.tags
  )

  private_service_connection {
    name = coalesce(
      each.value.private_service_connection_name, "${each.key}-connection"
    )

    is_manual_connection              = each.value.is_manual_connection
    private_connection_resource_id    = each.value.private_connection_resource_alias != null ? null : azurerm_storage_account.this.id
    private_connection_resource_alias = each.value.private_connection_resource_alias
    subresource_names                 = each.value.subresource_name != null ? [each.value.subresource_name] : ["blob"]
    request_message                   = each.value.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_resource_ids != null ? { "this" = each.value.private_dns_zone_resource_ids } : {}

    content {
      name                 = "default"
      private_dns_zone_ids = private_dns_zone_group.value
    }
  }

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations != null ? each.value.ip_configurations : {}

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      member_name        = ip_configuration.value.member_name
      subresource_name   = ip_configuration.value.subresource_name
    }
  }
}

# containers
resource "azurerm_storage_container" "this" {
  for_each = nonsensitive(var.storage.blob_properties != null ? var.storage.blob_properties.containers : {})

  name = coalesce(
    var.storage.blob_properties.containers[each.key].name,
    each.key
  )

  storage_account_id                = azurerm_storage_account.this.id
  container_access_type             = var.storage.blob_properties.containers[each.key].access_type
  default_encryption_scope          = var.storage.blob_properties.containers[each.key].default_encryption_scope
  encryption_scope_override_enabled = var.storage.blob_properties.containers[each.key].default_encryption_scope != null ? var.storage.blob_properties.containers[each.key].encryption_scope_override_enabled : null
  metadata                          = var.storage.blob_properties.containers[each.key].metadata
}

# container immutability policies
resource "azurerm_storage_container_immutability_policy" "this" {
  for_each = {
    for key, container in(var.storage.blob_properties != null ? var.storage.blob_properties.containers : {}) : key => container
    if container.immutability_policy != null
  }

  storage_container_resource_manager_id = azurerm_storage_container.this[each.key].resource_manager_id
  immutability_period_in_days           = each.value.immutability_policy.immutability_period_in_days
  protected_append_writes_enabled       = each.value.immutability_policy.protected_append_writes_enabled
  protected_append_writes_all_enabled   = each.value.immutability_policy.protected_append_writes_all_enabled
  locked                                = each.value.immutability_policy.locked
}

# queues
resource "azurerm_storage_queue" "this" {
  for_each = nonsensitive(var.storage.queue_properties != null ? var.storage.queue_properties.queues : {})

  name = coalesce(
    each.value.name,
    each.key
  )

  storage_account_id = azurerm_storage_account.this.id
  metadata           = each.value.metadata
}

# queue properties
resource "azurerm_storage_account_queue_properties" "this" {
  for_each = var.storage.queue_properties != null && anytrue([
    length(var.storage.queue_properties.cors_rules) > 0,
    var.storage.queue_properties.logging != null,
    var.storage.queue_properties.minute_metrics != null,
    var.storage.queue_properties.hour_metrics != null,
  ]) ? { "this" = var.storage.queue_properties } : {}

  storage_account_id = azurerm_storage_account.this.id

  dynamic "cors_rule" {
    for_each = each.value.cors_rules != null ? each.value.cors_rules : {}

    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "logging" {
    for_each = each.value.logging != null ? { "this" = each.value.logging } : {}

    content {
      version               = logging.value.version
      delete                = logging.value.delete
      read                  = logging.value.read
      write                 = logging.value.write
      retention_policy_days = logging.value.retention_policy_days
    }
  }

  dynamic "minute_metrics" {
    for_each = each.value.minute_metrics != null ? { "this" = each.value.minute_metrics } : {}

    content {
      version               = minute_metrics.value.version
      include_apis          = minute_metrics.value.include_apis
      retention_policy_days = minute_metrics.value.retention_policy_days
    }
  }

  dynamic "hour_metrics" {
    for_each = each.value.hour_metrics != null ? { "this" = each.value.hour_metrics } : {}

    content {
      version               = hour_metrics.value.version
      include_apis          = hour_metrics.value.include_apis
      retention_policy_days = hour_metrics.value.retention_policy_days
    }
  }
}

resource "azurerm_storage_account_local_user" "this" {
  for_each = nonsensitive(merge(
    var.storage.blob_properties != null ? {
      for kv in flatten([
        for container_name, container_def in lookup(var.storage.blob_properties, "containers", {}) : [
          for user_key, user_def in lookup(container_def, "local_users", {}) : {
            key = "${container_name}-${user_key}"
            value = {
              service             = "blob"
              resource_name       = azurerm_storage_container.this[container_name].name
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
    var.storage.share_properties != null ? {
      for kv in flatten([
        for share_name, share_def in lookup(var.storage.share_properties, "shares", {}) : [
          for user_key, user_def in lookup(share_def, "local_users", {}) : {
            key = "${share_name}-${user_key}"
            value = {
              service             = "file"
              resource_name       = azurerm_storage_share.this[share_name].name
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
  storage_account_id   = azurerm_storage_account.this.id

  dynamic "ssh_authorized_key" {
    for_each = each.value.ssh_authorized_keys != null ? each.value.ssh_authorized_keys : {}

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
resource "azurerm_storage_share" "this" {
  for_each = var.storage.share_properties != null ? var.storage.share_properties.shares : {}

  name = coalesce(
    each.value.name,
    each.key
  )

  storage_account_id = azurerm_storage_account.this.id
  quota              = each.value.quota
  metadata           = each.value.metadata
  access_tier        = contains(["FileStorage"], var.storage.account_kind) ? null : each.value.access_tier
  enabled_protocol   = each.value.protocol

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : {}

    content {
      id = acl.key

      dynamic "access_policy" {
        for_each = acl.value.access_policy != null ? { "this" = acl.value.access_policy } : {}

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
resource "azurerm_storage_table" "this" {
  for_each = var.storage.tables != null ? var.storage.tables : {}

  name = coalesce(
    each.value.name,
    each.key
  )

  storage_account_id = azurerm_storage_account.this.id

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : {}

    content {
      id = acl.key

      dynamic "access_policy" {
        for_each = acl.value.access_policy != null ? { "this" = acl.value.access_policy } : {}

        content {
          permissions = access_policy.value.permissions
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
        }
      }
    }
  }
}

# file systems
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each = var.storage.file_systems != null ? var.storage.file_systems : {}

  name = coalesce(
    each.value.name,
    each.key
  )

  storage_account_id       = azurerm_storage_account.this.id
  properties               = each.value.properties
  owner                    = each.value.owner
  group                    = each.value.group
  default_encryption_scope = each.value.default_encryption_scope

  dynamic "ace" {
    for_each = each.value.ace != null ? each.value.ace : {}
    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = ace.value.scope
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "this" {
  for_each = merge([
    for fs_key, fs in(var.storage.file_systems != null ? var.storage.file_systems : {}) : {
      for pa_key, pa in(fs.paths != null ? fs.paths : {}) : pa_key => {
        filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this[fs_key].name
        storage_account_id = azurerm_storage_account.this.id
        owner              = pa.owner
        group              = pa.group
        resource           = pa.resource
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
  resource           = each.value.resource

  dynamic "ace" {
    for_each = each.value.ace != null ? each.value.ace : {}

    content {
      permissions = ace.value.permissions
      type        = ace.value.type
      id          = ace.value.type == "group" || ace.value.type == "user" ? ace.value.id : null
      scope       = ace.value.scope
    }
  }
}

# management policies
resource "azurerm_storage_management_policy" "this" {
  for_each = var.storage.management_policy != null ? { "this" = var.storage.management_policy } : {}

  storage_account_id = azurerm_storage_account.this.id

  dynamic "rule" {
    for_each = lookup(
      each.value, "rules", {}
    )

    content {
      name    = coalesce(rule.value.name, rule.key)
      enabled = rule.value.enabled

      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types

        dynamic "match_blob_index_tag" {
          for_each = rule.value.filters.match_blob_index_tag != null ? rule.value.filters.match_blob_index_tag : {}

          content {
            name      = match_blob_index_tag.value.name
            operation = match_blob_index_tag.value.operation
            value     = match_blob_index_tag.value.value
          }
        }
      }

      dynamic "actions" {
        for_each = rule.value.actions != null ? { "this" = rule.value.actions } : {}

        content {
          dynamic "base_blob" {
            for_each = actions.value.base_blob != null ? { "this" = actions.value.base_blob } : {}

            content {
              tier_to_cool_after_days_since_modification_greater_than        = base_blob.value.tier_to_cool_after_days_since_modification_greater_than
              tier_to_cool_after_days_since_last_access_time_greater_than    = base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than
              tier_to_archive_after_days_since_modification_greater_than     = base_blob.value.tier_to_archive_after_days_since_modification_greater_than
              tier_to_archive_after_days_since_last_access_time_greater_than = base_blob.value.tier_to_archive_after_days_since_last_access_time_greater_than
              delete_after_days_since_modification_greater_than              = base_blob.value.delete_after_days_since_modification_greater_than
              delete_after_days_since_last_access_time_greater_than          = base_blob.value.delete_after_days_since_last_access_time_greater_than
              auto_tier_to_hot_from_cool_enabled                             = base_blob.value.auto_tier_to_hot_from_cool_enabled
              delete_after_days_since_creation_greater_than                  = base_blob.value.delete_after_days_since_creation_greater_than
              tier_to_archive_after_days_since_creation_greater_than         = base_blob.value.tier_to_archive_after_days_since_creation_greater_than
              tier_to_cool_after_days_since_creation_greater_than            = base_blob.value.tier_to_cool_after_days_since_creation_greater_than
              tier_to_cold_after_days_since_creation_greater_than            = base_blob.value.tier_to_cold_after_days_since_creation_greater_than
              tier_to_cold_after_days_since_modification_greater_than        = base_blob.value.tier_to_cold_after_days_since_modification_greater_than
              tier_to_cold_after_days_since_last_access_time_greater_than    = base_blob.value.tier_to_cold_after_days_since_last_access_time_greater_than
              tier_to_archive_after_days_since_last_tier_change_greater_than = base_blob.value.tier_to_archive_after_days_since_last_tier_change_greater_than
            }
          }

          dynamic "snapshot" {
            for_each = actions.value.snapshot != null ? { "this" = actions.value.snapshot } : {}

            content {
              change_tier_to_archive_after_days_since_creation               = snapshot.value.change_tier_to_archive_after_days_since_creation
              change_tier_to_cool_after_days_since_creation                  = snapshot.value.change_tier_to_cool_after_days_since_creation
              delete_after_days_since_creation_greater_than                  = snapshot.value.delete_after_days_since_creation_greater_than
              tier_to_archive_after_days_since_last_tier_change_greater_than = snapshot.value.tier_to_archive_after_days_since_last_tier_change_greater_than
              tier_to_cold_after_days_since_creation_greater_than            = snapshot.value.tier_to_cold_after_days_since_creation_greater_than
            }
          }

          dynamic "version" {
            for_each = actions.value.version != null ? { "this" = actions.value.version } : {}

            content {
              change_tier_to_archive_after_days_since_creation               = version.value.change_tier_to_archive_after_days_since_creation
              change_tier_to_cool_after_days_since_creation                  = version.value.change_tier_to_cool_after_days_since_creation
              delete_after_days_since_creation                               = version.value.delete_after_days_since_creation
              tier_to_cold_after_days_since_creation_greater_than            = version.value.tier_to_cold_after_days_since_creation_greater_than
              tier_to_archive_after_days_since_last_tier_change_greater_than = version.value.tier_to_archive_after_days_since_last_tier_change_greater_than
            }
          }
        }
      }
    }
  }
  depends_on = [azurerm_storage_container.this]
}

resource "azurerm_role_assignment" "this" {
  for_each = lookup(var.storage, "customer_managed_key", null) != null ? { "this" = var.storage.customer_managed_key } : {}

  scope                                  = each.value.key_vault_id
  name                                   = each.value.role_assignment_name
  role_definition_name                   = each.value.role_definition_name
  role_definition_id                     = each.value.role_definition_id
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  description                            = each.value.description
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  principal_type                         = each.value.principal_type
}
