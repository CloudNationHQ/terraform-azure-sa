variable "storage" {
  description = "Contains all storage configuration"
  type = object({
    name                              = string
    resource_group_name               = optional(string, null)
    location                          = optional(string, null)
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "GRS")
    account_kind                      = optional(string, "StorageV2")
    access_tier                       = optional(string, "Hot")
    infrastructure_encryption_enabled = optional(bool, false)
    https_traffic_only_enabled        = optional(bool, true)
    min_tls_version                   = optional(string, "TLS1_2")
    edge_zone                         = optional(string, null)
    table_encryption_key_type         = optional(string, null)
    queue_encryption_key_type         = optional(string, null)
    allowed_copy_scope                = optional(string, null)
    large_file_share_enabled          = optional(bool, false)
    allow_nested_items_to_be_public   = optional(bool, false)
    shared_access_key_enabled         = optional(bool, true)
    public_network_access_enabled     = optional(bool, true)
    is_hns_enabled                    = optional(bool, false)
    sftp_enabled                      = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    cross_tenant_replication_enabled  = optional(bool, false)
    local_user_enabled                = optional(bool, null)
    dns_endpoint_type                 = optional(string, null)
    default_to_oauth_authentication   = optional(bool, false)
    tags                              = optional(map(string))
    network_rules = optional(object({
      bypass                     = optional(list(string), ["None"])
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string), null)
      virtual_network_subnet_ids = optional(list(string), null)
      private_link_access = optional(map(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string, null)
      })), {})
    }), null)
    blob_properties = optional(object({
      last_access_time_enabled      = optional(bool, false)
      versioning_enabled            = optional(bool, false)
      change_feed_enabled           = optional(bool, false)
      change_feed_retention_in_days = optional(number, null)
      default_service_version       = optional(string, null)
      cors_rules = optional(map(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), {})
      delete_retention_policy = optional(object({
        days                     = optional(number, 7)
        permanent_delete_enabled = optional(bool, null)
      }), null)
      restore_policy = optional(object({
        days = optional(number, 7)
      }), null)
      container_delete_retention_policy = optional(object({
        days = optional(number, 7)
      }), null)
      containers = optional(map(object({
        name                              = optional(string)
        access_type                       = optional(string, "private")
        default_encryption_scope          = optional(string, null)
        encryption_scope_override_enabled = optional(bool, true)
        metadata                          = optional(map(string), {})
        local_users = optional(map(object({
          name                 = optional(string)
          home_directory       = optional(string, null)
          ssh_key_enabled      = optional(bool, false)
          ssh_password_enabled = optional(bool, false)
          ssh_authorized_keys = optional(map(object({
            description = optional(string, null)
            key         = string
          })), {})
          permission_scope = optional(object({
            permissions = optional(object({
              read   = optional(bool, false)
              write  = optional(bool, false)
              list   = optional(bool, false)
              create = optional(bool, false)
              delete = optional(bool, false)
            }), {})
          }), null)
        })), {})
      })), {})
    }), null)
    share_properties = optional(object({
      cors_rules = optional(map(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), {})
      retention_policy = optional(object({
        days = optional(number, 7)
      }), null)
      smb = optional(object({
        versions                        = optional(list(string), [])
        authentication_types            = optional(list(string), [])
        channel_encryption_type         = optional(list(string), [])
        multichannel_enabled            = optional(bool, false)
        kerberos_ticket_encryption_type = optional(list(string), [])
      }), null)
      azure_files_authentication = optional(object({
        directory_type                 = optional(string, "AD")
        default_share_level_permission = optional(string, null)
        active_directory = optional(object({
          domain_name         = string
          domain_guid         = string
          forest_name         = optional(string, null)
          domain_sid          = optional(string, null)
          storage_sid         = optional(string, null)
          netbios_domain_name = optional(string, null)
        }), null)
      }), null)
      shares = optional(map(object({
        name        = optional(string)
        quota       = number
        access_tier = optional(string, "Hot")
        protocol    = optional(string, "SMB")
        metadata    = optional(map(string), {})
        acl = optional(map(object({
          access_policy = optional(object({
            permissions = string
            start       = optional(string, null)
            expiry      = optional(string, null)
          }), null)
        })), {})
        local_users = optional(map(object({
          name                 = optional(string)
          home_directory       = optional(string, null)
          ssh_key_enabled      = optional(bool, false)
          ssh_password_enabled = optional(bool, false)
          ssh_authorized_keys = optional(map(object({
            description = optional(string, null)
            key         = string
          })), {})
          permission_scope = optional(object({
            permissions = optional(object({
              read   = optional(bool, false)
              write  = optional(bool, false)
              list   = optional(bool, false)
              create = optional(bool, false)
              delete = optional(bool, false)
            }), {})
          }), null)
        })), {})
      })), {})
    }), null)
    queue_properties = optional(object({
      cors_rules = optional(map(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), {})
      logging = optional(object({
        version               = optional(string, "1.0")
        delete                = optional(bool, false)
        read                  = optional(bool, false)
        write                 = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }), null)
      minute_metrics = optional(object({
        enabled               = optional(bool, false)
        version               = optional(string, "1.0")
        include_apis          = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }), null)
      hour_metrics = optional(object({
        enabled               = optional(bool, false)
        version               = optional(string, "1.0")
        include_apis          = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }), null)
      queues = optional(map(object({
        name     = optional(string)
        metadata = optional(map(string), {})
      })), {})
    }), null)
    tables = optional(map(object({
      name = optional(string)
      acl = optional(map(object({
        access_policy = optional(object({
          permissions = string
          start       = optional(string, null)
          expiry      = optional(string, null)
        }), null)
      })), {})
    })), {})
    file_systems = optional(map(object({
      name                     = optional(string)
      properties               = optional(map(string), {})
      owner                    = optional(string, null)
      group                    = optional(string, null)
      default_encryption_scope = optional(string, null)
      ace = optional(map(object({
        permissions = string
        type        = string
        id          = optional(string, null) # Required for user or group types
        scope       = optional(string, "access")
      })), {})
      paths = optional(map(object({
        path  = optional(string, null)
        owner = optional(string, null)
        group = optional(string, null)
        ace = optional(map(object({
          permissions = string
          type        = string
          id          = optional(string, null) # Required for user or group types
          scope       = optional(string, "access")
        })), {})
      })), {})
    })), {})
    management_policy = optional(object({
      rules = optional(map(object({
        name    = optional(string, null)
        enabled = optional(bool, true)
        filters = optional(object({
          prefix_match = optional(list(string), null)
          blob_types   = optional(list(string), [])
          match_blob_index_tag = optional(map(object({
            name      = optional(string, null)
            operation = optional(string, "==")
            value     = optional(string, null)
          })), {})
        }), {})
        actions = optional(object({
          base_blob = optional(object({
            tier_to_cool_after_days_since_modification_greater_than        = optional(number, null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = optional(number, null)
            tier_to_archive_after_days_since_modification_greater_than     = optional(number, null)
            tier_to_archive_after_days_since_last_access_time_greater_than = optional(number, null)
            delete_after_days_since_modification_greater_than              = optional(number, null)
            delete_after_days_since_last_access_time_greater_than          = optional(number, null)
            auto_tier_to_hot_from_cool_enabled                             = optional(bool, null)
            delete_after_days_since_creation_greater_than                  = optional(number, null)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number, null)
            tier_to_cool_after_days_since_creation_greater_than            = optional(number, null)
            tier_to_archive_after_days_since_creation_greater_than         = optional(number, null)
            tier_to_cold_after_days_since_modification_greater_than        = optional(number, null)
            tier_to_cold_after_days_since_last_access_time_greater_than    = optional(number, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number, null)
          }), {})
          snapshot = optional(object({
            change_tier_to_archive_after_days_since_creation               = optional(number, null)
            change_tier_to_cool_after_days_since_creation                  = optional(number, null)
            delete_after_days_since_creation_greater_than                  = optional(number, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number, null)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number, null)
          }), {})
          version = optional(object({
            change_tier_to_archive_after_days_since_creation               = optional(number, null)
            change_tier_to_cool_after_days_since_creation                  = optional(number, null)
            delete_after_days_since_creation                               = optional(number, null)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number, null)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number, null)
          }), {})
        }))
      })), {})
    }), null)
    policy = optional(object({
      sas = optional(object({
        expiration_action = string
        expiration_period = string
      }), null)
      immutability = optional(object({
        state                         = string
        period_since_creation_in_days = number
        allow_protected_append_writes = bool
      }), null)
    }), null)
    routing = optional(object({
      choice                      = optional(string, "MicrosoftRouting")
      publish_internet_endpoints  = optional(bool, false)
      publish_microsoft_endpoints = optional(bool, false)
    }), null)
    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool, null)
    }), null)
    customer_managed_key = optional(object({
      key_vault_key_id                       = optional(string, null)
      managed_hsm_key_id                     = optional(string, null)
      key_vault_id                           = string
      role_assignment_name                   = optional(string, null)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      principal_id                           = string
      user_assigned_identity_id              = string
    }), null)
    static_website = optional(object({
      index_document     = optional(string, null)
      error_404_document = optional(string, null)
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
      name         = optional(string, null)
    }), null)
  })

  validation {
    condition     = var.storage.location != null || var.location != null
    error_message = "location must be provided either in the storage object or as a separate variable."
  }

  validation {
    condition     = var.storage.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the storage object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
