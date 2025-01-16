# Shares

This deploys storage shares

## Types

```hcl
storage = object({
  name           = string
  location       = string
  resource_group = string
  share_properties = optional(object({
    smb = optional(object({
      versions             = list(string)
      authentication_types = list(string)
    }))
    retention_policy = optional(object({
      days = number
    }))
    shares = optional(map(object({
      quota    = number
      metadata = optional(map(string))
      acl = optional(map(object({
        access_policy = optional(object({
          permissions = string
          start       = optional(string)
          expiry      = optional(string)
        }))
      })))
    })))
  }))
})
```
