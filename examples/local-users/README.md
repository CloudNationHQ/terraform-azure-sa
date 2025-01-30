# Local Users

This deploys local users on storage shares or containers

## Types

```hcl
storage = object({
  name           = string
  location       = string
  resource_group = string
  blob_properties = optional(object({
    versioning_enabled       = optional(bool)
    last_access_time_enabled = optional(bool)
    change_feed_enabled      = optional(bool)
    restore_policy = optional(object({
      days = number
    }))
    delete_retention_policy = optional(object({
      days                     = number
      permanent_delete_enabled = optional(bool)
    }))
    container_delete_retention_policy = optional(object({
      days = number
    }))
    containers = optional(map(object({
      local_users = optional(map(object({
        name                 = string
        ssh_key_enabled      = optional(bool)
        ssh_password_enabled = optional(bool)
        home_directory       = string
        ssh_authorized_keys = optional(map(object({
          key = string
        })))
        permissions = object({
          read  = bool
          write = bool
        })
      })))
    })))
  }))
  share_properties = optional(object({
    smb = optional(object({
      versions             = list(string)
      authentication_types = list(string)
    }))
    retention_policy = optional(object({
      days = number
    }))
    shares = optional(map(object({
      quota = number
      local_users = optional(map(object({
        name                 = string
        ssh_key_enabled      = optional(bool)
        ssh_password_enabled = optional(bool)
        home_directory       = string
        ssh_authorized_keys = optional(map(object({
          key = string
        })))
        permissions = optional(object({
          read   = bool
          write  = bool
          delete = bool
        }))
      })))
    })))
  }))
})
```
