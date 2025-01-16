# Management Policies

This deploys management policies

## Types

```hcl
storage = object({
  name              = string
  location          = string
  resource_group    = string
  threat_protection = optional(bool)
  blob_properties = optional(object({
    last_access_time_enabled = optional(bool)
  }))
  management_policy = optional(object({
    rules = map(object({
      enabled = optional(bool)
      filters = optional(object({
        prefix_match = optional(list(string))
        blob_types   = optional(list(string))
        match_blob_index_tag = optional(map(object({
          name      = string
          operation = string
          value     = string
        })))
      }))
      actions = object({
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
        }))
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
      })
    }))
  }))
})
```

## Notes

This is the complete usage. In real world scenarios often specific properties are choosen thats fits in categories like cost optimization, compliancy or creation based rules.

The provider intentionally injects the value -1 into policy action properties when they are not specified. This behavior is designed and controlled at an upstream level.
