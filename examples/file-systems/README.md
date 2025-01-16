# File Systems

This deploys storage data lake gen2 file systems

## Types

```hcl
storage = object({
  name           = string
  location       = string
  resource_group = string
  is_hns_enabled = optional(bool)
  sftp_enabled   = optional(bool)
  file_systems = optional(map(object({
    owner = optional(string)
    group = optional(string)
    properties = optional(map(string))
    ace = optional(map(object({
      permissions = string
      type        = string
      id          = optional(string)
      scope       = optional(string)
    })))
    paths = optional(map(object({
      owner = optional(string)
      group = optional(string)
      ace = optional(map(object({
        permissions = string
        type        = string
        id          = optional(string)
        scope       = optional(string)
      })))
    })))
  })))
})
```

## Notes

Currently, the path resources only support "directory" type, no other resource types are available.
