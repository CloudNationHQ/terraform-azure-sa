module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.23"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 3.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    keys = {
      finance1 = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]
      }
      sftp1 = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]
      }
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 3.0"

  naming = local.naming

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name


    blob_properties = {
      versioning_enabled       = true
      last_access_time_enabled = true
      change_feed_enabled      = true

      restore_policy = {
        days = 8
      }

      delete_retention_policy = {
        days                     = 10
        permanent_delete_enabled = false
      }

      container_delete_retention_policy = {
        days = 10
      }

      containers = {
        sc1 = {
          local_users = {
            sftp1 = {
              ssh_key_enabled = true
              home_directory  = "/home/sftp-user1"

              ssh_authorized_keys = {
                key1 = {
                  key = module.kv.keys.sftp1.public_key_openssh
                }
              }
              permission_scope = {
                permissions = {
                  read  = true
                  write = true
                }
              }
            }
          }
        }
      }
    }

    share_properties = {
      smb = {
        versions             = ["SMB3.1.1"]
        authentication_types = ["Kerberos"]
      }

      retention_policy = {
        days = 8
      }

      shares = {
        fs1 = {
          local_users = {
            finance1 = {
              ssh_key_enabled = true
              home_directory  = "finance"

              ssh_authorized_keys = {
                key1 = {
                  key = module.kv.keys.finance1.public_key_openssh
                }
              }
              permission_scope = {
                permissions = {
                  read   = true
                  write  = true
                  delete = true
                }
              }
            }
          }
          quota = 50
        }
      }
    }
  }
}
