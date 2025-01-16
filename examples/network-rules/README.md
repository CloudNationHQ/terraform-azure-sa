# Network Rules

This deploys network rules

## Types

```hcl
storage = object({
  name           = string
  location       = string
  resource_group = string
  network_rules = optional(object({
    virtual_network_subnet_ids = optional(list(string))
    private_link_access = optional(map(object({
      endpoint_resource_id = string
      endpoint_tenant_id  = optional(string)
    })))
  }))
})
```
