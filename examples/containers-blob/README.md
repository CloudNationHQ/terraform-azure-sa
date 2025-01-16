# Containers Blob

This deploys storage containers

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
      metadata = optional(map(string))
    })))
  }))
})
```
