This example highlights setting up storage queues, streamlining message handling between services with controlled access and reliable delivery.

## Usage

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.3"

  naming = local.naming

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    queue_properties = {
      logging = {
        read              = true
        retention_in_days = 8
      }

      queues = {
        q1 = {
          metadata = {
            environment = "dev"
            owner       = "finance team"
            purpose     = "transaction_processing"
          }
        }
      }
    }
  }
}
```
