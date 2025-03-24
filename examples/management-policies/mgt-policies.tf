locals {
  management_policies = {
    rules = {
      rule1 = {
        filters = {
          prefix_match = ["container1/prefix1"]
          blob_types   = ["blockBlob"]
        }
        actions = {
          base_blob = {
            tier_to_cool_after_days_since_modification_greater_than    = 11
            tier_to_archive_after_days_since_modification_greater_than = 51
            delete_after_days_since_modification_greater_than          = 101
          }
          snapshot = {
            change_tier_to_archive_after_days_since_creation = 90
            change_tier_to_cool_after_days_since_creation    = 23
            delete_after_days_since_creation_greater_than    = 31
          }
          version = {
            change_tier_to_archive_after_days_since_creation = 9
            change_tier_to_cool_after_days_since_creation    = 90
            delete_after_days_since_creation                 = 3
          }
        }
      },
      rule2 = {
        filters = {
          prefix_match = ["container1/prefix3"]
          blob_types   = ["blockBlob"]
        }
        actions = {
          base_blob = {
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
