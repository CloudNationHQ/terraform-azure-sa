This example details a storage account setup with a private endpoint, enhancing security by restricting data access to a private network.

## Usage: private endpoint

```hcl
module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.7"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    private_endpoint = {
      name         = module.naming.private_endpoint.name
      dns_zones    = [module.private_dns.zone.id]
      subnet       = module.network.subnets.sn1.id
      subresources = ["blob"]
    }
  }
}
```

To enable private link, the below private dns submodule can be employed:

```hcl
module "private_dns" {
  source  = "cloudnationhq/sa/azure//modules/private-dns"
  version = "~> 0.1"

  providers = {
    azurerm = azurerm.connectivity
  }

  zone = {
    name          = "privatelink.blob.core.windows.net"
    resourcegroup = "rg-dns-shared-001"
    vnet          = module.network.vnet.id
  }
}
```
