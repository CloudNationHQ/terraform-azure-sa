locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["storage_container", "storage_share", "storage_queue", "storage_table"]
}

locals {
  blob_properties = {
    cors_rules = {
      rule1 = {
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
      rule2 = {
        allowed_headers    = ["*"]
        allowed_methods    = ["PUT"]
        allowed_origins    = ["*"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    }
    versioning_enabled       = true
    last_access_time_enabled = true
    change_feed_enabled      = true

    restore_policy = {
      days = 8
    }

    delete_retention_policy = {
      days = 10
    }

    container_delete_retention_policy = {
      days = 10
    }

    containers = {
      sc1 = {
        access_type = "private"
        metadata = {
          project = "marketing"
          owner   = "marketing team"
        }
      }
    }
  }
  queue_properties = {
    cors_rules = {
      rule1 = {
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    }
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
  share_properties = {
    cors_rules = {
      rule1 = {
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    }
    smb = {
      versions             = ["SMB3.1.1"]
      authentication_types = ["Kerberos"]
    }

    retention_policy = {
      days = 8
    }

    shares = {
      fs1 = {
        quota = 50
        metadata = {
          environment = "dev"
          owner       = "finance team"
        }
      }
    }
  }
  mgt_policy = {
    rules = {
      rule1 = {
        filters = {
          filter_specs = {
            prefix_match = ["container1/prefix1"]
            blob_types   = ["blockBlob"]
          }
        }
        actions = {
          base_blob = {
            blob_specs = {
              tier_to_cool_after_days_since_modification_greater_than    = 11
              tier_to_archive_after_days_since_modification_greater_than = 51
              delete_after_days_since_modification_greater_than          = 101
            }
          }
          snapshot = {
            snapshot_specs = {
              change_tier_to_archive_after_days_since_creation = 90
              change_tier_to_cool_after_days_since_creation    = 23
              delete_after_days_since_creation_greater_than    = 31
            }
          }
          version = {
            version_specs = {
              change_tier_to_archive_after_days_since_creation = 9
              change_tier_to_cool_after_days_since_creation    = 90
              delete_after_days_since_creation                 = 3
            }
          }
        }
      },
      rule2 = {
        filters = {
          filter_specs = {
            prefix_match = ["container1/prefix3"]
            blob_types   = ["blockBlob"]
          }
        }
        actions = {
          base_blob = {
            blob_specs = {
              tier_to_cool_after_days_since_last_access_time_greater_than    = 30
              tier_to_archive_after_days_since_last_access_time_greater_than = 90
              delete_after_days_since_last_access_time_greater_than          = 365
              auto_tier_to_hot_from_cool_enabled                             = true
            }
          }
        }
      }
    }
  }
}
