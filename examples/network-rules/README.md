This example shows how to use network rules to enhance security with secure access control.

## Usage:

```hcl
module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    public_access = false

    network_rules = {
      virtual_network_subnet_ids = [module.network.subnets.sn1.id]
    }
  }
}
```
