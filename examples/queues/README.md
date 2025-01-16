# Queues

This deploys storage queues

## Types

```hcl
storage = object({
  name           = string
  location       = string
  resource_group = string
  queue_properties = optional(object({
    logging = optional(object({
      read                  = optional(bool)
      write                 = optional(bool)
      delete                = optional(bool)
      version               = optional(string)
      retention_policy_days = optional(number)
    }))
    queues = optional(map(object({
      metadata = optional(map(string))
    })))
  }))
})
```
