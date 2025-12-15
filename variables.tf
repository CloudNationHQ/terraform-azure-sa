variable "storage" {
  description = "Contains all storage configuration"
  type = object({
    name                              = string
    resource_group_name               = optional(string)
    location                          = optional(string)
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "GRS")
    account_kind                      = optional(string, "StorageV2")
    access_tier                       = optional(string)
    infrastructure_encryption_enabled = optional(bool, false)
    https_traffic_only_enabled        = optional(bool, true)
    min_tls_version                   = optional(string, "TLS1_2")
    edge_zone                         = optional(string)
    table_encryption_key_type         = optional(string)
    queue_encryption_key_type         = optional(string)
    allowed_copy_scope                = optional(string)
    large_file_share_enabled          = optional(bool, false)
    allow_nested_items_to_be_public   = optional(bool, false)
    shared_access_key_enabled         = optional(bool, true)
    public_network_access_enabled     = optional(bool, true)
    is_hns_enabled                    = optional(bool, false)
    sftp_enabled                      = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    cross_tenant_replication_enabled  = optional(bool, false)
    local_user_enabled                = optional(bool)
    dns_endpoint_type                 = optional(string)
    default_to_oauth_authentication   = optional(bool, false)
    provisioned_billing_model_version = optional(string)
    tags                              = optional(map(string))
    network_rules = optional(object({
      bypass                     = optional(set(string), ["None"])
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(set(string))
      virtual_network_subnet_ids = optional(set(string))
      private_link_access = optional(map(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })), {})
    }))
    blob_properties = optional(object({
      last_access_time_enabled      = optional(bool, false)
      versioning_enabled            = optional(bool, false)
      change_feed_enabled           = optional(bool, false)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      cors_rules = optional(map(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), {})
      delete_retention_policy = optional(object({
        days                     = optional(number, 7)
        permanent_delete_enabled = optional(bool)
      }))
      restore_policy = optional(object({
        days = optional(number, 7)
      }))
      container_delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))
      containers = optional(map(object({
        name                              = optional(string)
        access_type                       = optional(string, "private")
        default_encryption_scope          = optional(string)
        encryption_scope_override_enabled = optional(bool, true)
        metadata                          = optional(map(string), {})
        immutability_policy = optional(object({
          immutability_period_in_days         = number
          protected_append_writes_enabled     = optional(bool)
          protected_append_writes_all_enabled = optional(bool)
          locked                              = optional(bool)
        }))
        local_users = optional(map(object({
          name                 = optional(string)
          home_directory       = optional(string)
          ssh_key_enabled      = optional(bool, false)
          ssh_password_enabled = optional(bool, false)
          ssh_authorized_keys = optional(map(object({
            description = optional(string)
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
          }))
        })), {})
      })), {})
    }))
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
      }))
      smb = optional(object({
        versions                        = optional(list(string), [])
        authentication_types            = optional(list(string), [])
        channel_encryption_type         = optional(list(string), [])
        multichannel_enabled            = optional(bool, false)
        kerberos_ticket_encryption_type = optional(list(string), [])
      }))
      azure_files_authentication = optional(object({
        directory_type                 = optional(string, "AD")
        default_share_level_permission = optional(string)
        active_directory = optional(object({
          domain_name         = string
          domain_guid         = string
          forest_name         = optional(string)
          domain_sid          = optional(string)
          storage_sid         = optional(string)
          netbios_domain_name = optional(string)
        }))
      }))
      shares = optional(map(object({
        name        = optional(string)
        quota       = number
        access_tier = optional(string, "Hot")
        protocol    = optional(string, "SMB")
        metadata    = optional(map(string), {})
        acl = optional(map(object({
          access_policy = optional(object({
            permissions = string
            start       = optional(string)
            expiry      = optional(string)
          }))
        })), {})
        local_users = optional(map(object({
          name                 = optional(string)
          home_directory       = optional(string)
          ssh_key_enabled      = optional(bool, false)
          ssh_password_enabled = optional(bool, false)
          ssh_authorized_keys = optional(map(object({
            description = optional(string)
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
          }))
        })), {})
      })), {})
    }))
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
      }))
      minute_metrics = optional(object({
        enabled               = optional(bool, false)
        version               = optional(string, "1.0")
        include_apis          = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }))
      hour_metrics = optional(object({
        enabled               = optional(bool, false)
        version               = optional(string, "1.0")
        include_apis          = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }))
      queues = optional(map(object({
        name     = optional(string)
        metadata = optional(map(string), {})
      })), {})
    }))
    tables = optional(map(object({
      name = optional(string)
      acl = optional(map(object({
        access_policy = optional(object({
          permissions = string
          start       = optional(string)
          expiry      = optional(string)
        }))
      })), {})
    })), {})
    file_systems = optional(map(object({
      name                     = optional(string)
      properties               = optional(map(string), {})
      owner                    = optional(string)
      group                    = optional(string)
      default_encryption_scope = optional(string)
      ace = optional(map(object({
        permissions = string
        type        = string
        id          = optional(string)
        scope       = optional(string, "access")
      })), {})
      paths = optional(map(object({
        path     = optional(string)
        owner    = optional(string)
        group    = optional(string)
        resource = optional(string, "directory")
        ace = optional(map(object({
          permissions = string
          type        = string
          id          = optional(string) # Required for user or group types
          scope       = optional(string, "access")
        })), {})
      })), {})
    })), {})
    management_policy = optional(object({
      rules = optional(map(object({
        name    = optional(string)
        enabled = optional(bool, true)
        filters = optional(object({
          prefix_match = optional(list(string))
          blob_types   = optional(list(string), [])
          match_blob_index_tag = optional(map(object({
            name      = optional(string)
            operation = optional(string, "==")
            value     = optional(string)
          })), {})
        }), {})
        actions = optional(object({
          base_blob = optional(object({
            tier_to_cool_after_days_since_modification_greater_than        = optional(number)
            tier_to_cool_after_days_since_last_access_time_greater_than    = optional(number)
            tier_to_archive_after_days_since_modification_greater_than     = optional(number)
            tier_to_archive_after_days_since_last_access_time_greater_than = optional(number)
            delete_after_days_since_modification_greater_than              = optional(number)
            delete_after_days_since_last_access_time_greater_than          = optional(number)
            auto_tier_to_hot_from_cool_enabled                             = optional(bool)
            delete_after_days_since_creation_greater_than                  = optional(number)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number)
            tier_to_cool_after_days_since_creation_greater_than            = optional(number)
            tier_to_archive_after_days_since_creation_greater_than         = optional(number)
            tier_to_cold_after_days_since_modification_greater_than        = optional(number)
            tier_to_cold_after_days_since_last_access_time_greater_than    = optional(number)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          }), {})
          snapshot = optional(object({
            change_tier_to_archive_after_days_since_creation               = optional(number)
            change_tier_to_cool_after_days_since_creation                  = optional(number)
            delete_after_days_since_creation_greater_than                  = optional(number)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          }))
          version = optional(object({
            change_tier_to_archive_after_days_since_creation               = optional(number)
            change_tier_to_cool_after_days_since_creation                  = optional(number)
            delete_after_days_since_creation                               = optional(number)
            tier_to_cold_after_days_since_creation_greater_than            = optional(number)
            tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          }))
        }))
      })), {})
    }))
    policy = optional(object({
      sas = optional(object({
        expiration_action = string
        expiration_period = string
      }))
      immutability = optional(object({
        state                         = string
        period_since_creation_in_days = number
        allow_protected_append_writes = bool
      }))
    }), {})
    routing = optional(object({
      choice                      = optional(string, "MicrosoftRouting")
      publish_internet_endpoints  = optional(bool, false)
      publish_microsoft_endpoints = optional(bool, false)
    }))
    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))
    customer_managed_key = optional(object({
      key_vault_key_id                       = optional(string)
      managed_hsm_key_id                     = optional(string)
      key_vault_id                           = string
      role_assignment_name                   = optional(string)
      role_definition_name                   = optional(string, "Key Vault Crypto Officer")
      role_definition_id                     = optional(string)
      description                            = optional(string, "Key Vault Crypto Officer role assignment for storage account")
      principal_type                         = optional(string, "ServicePrincipal")
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      skip_service_principal_aad_check       = optional(bool, false)
      principal_id                           = string
      user_assigned_identity_id              = string
    }))
    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
      name         = optional(string)
    }))
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
