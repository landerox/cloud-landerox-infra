locals {
  buckets = {
    # ===========================================================================
    # BUCKET CONFIGURATION
    # ===========================================================================
    # Define your GCS buckets here.
    # Use the TEMPLATE below.

    # ===========================================================================
    # TEMPLATE: Standard Bucket
    # ===========================================================================
    # "dummy-bucket-name" = {
    #   location           = "US"        # (Optional) Regional/Multi-regional location. Default: var.region
    #   storage_class      = "STANDARD"  # (Optional) Default: STANDARD. Options: [STANDARD, NEARLINE, COLDLINE, ARCHIVE]
    #   uniform_access     = true        # (Optional) Enforce uniform access. Default: true
    #
    #   # --- Loggging & Versioning ---
    #   versioning_enabled = true        # (Optional) Enable object versioning. Default: false
    #   enable_logging     = false       # (Optional) Create separate log bucket. Default: false
    #
    #   # --- Lifecycle Management ---
    #   enable_lifecycle   = true        # (Optional) Enable lifecycle rules. Default: false
    #   lifecycle_rules = [              # (Optional) List of rules. Required if enable_lifecycle = true
    #     # Rule 1: Delete old versions
    #     {
    #       action_type                = "Delete"  # (Required) Options: [Delete, SetStorageClass, AbortIncompleteMultipartUpload]
    #       num_newer_versions         = 3         # (Optional) Condition: Keep N newer versions
    #       is_live                    = false     # (Optional) Condition: if false, only applies to archived versions
    #     },
    #     # Rule 2: Move to Nearline after 30 days
    #     {
    #       action_type                = "SetStorageClass" # (Required)
    #       action_storage_class       = "NEARLINE"        # (Required if action is SetStorageClass)
    #       age_days                   = 30                # (Optional) Condition: Age in days
    #     }
    #   ]
    #
    #   # --- Advanced Features (Provider 7.x) ---
    #   public_access_prevention = "enforced" # (Optional) Options: [enforced, inherited]. Default: enforced
    #   soft_delete_policy = {
    #     retention_duration_seconds = 604800 # (Optional) 7 days
    #   }
    #   autoclass = {
    #     enabled = true
    #   }
    #
    #   retention_policy = {             # (Optional) Data compliance
    #     retention_period = 2592000     # (Required) In seconds (e.g. 30 days)
    #     is_locked        = false       # (Optional) Warning: Irreversible if true.
    #   }
    #
    #   encryption = {                   # (Optional) CMEK
    #     default_kms_key_name = "projects/{p}/locations/{l}/keyRings/{r}/cryptoKeys/{k}" # (Required)
    #   }
    #
    #   cors = [                         # (Optional) Cross-Origin Resource Sharing
    #     {
    #       origin          = ["https://example.com"] # (Optional)
    #       method          = ["GET", "HEAD"]         # (Optional)
    #       response_header = ["*"]                   # (Optional)
    #       max_age_seconds = 3600                    # (Optional)
    #     }
    #   ]
    #
    #   # --- Labels ---
    #   labels = {                       # (Optional) Key-value pairs
    #     purpose = "general-storage"
    #     team    = "platform"
    #   }
    # }
    # ===========================================================================
    # DATA STORAGE
    # ===========================================================================
    "${var.project_id}-storage" = {
      location                 = "US"
      storage_class            = "STANDARD"
      uniform_access           = true
      public_access_prevention = "enforced"
      versioning_enabled       = true

      # Advanced data protection: 7-day recovery window for deleted objects
      soft_delete_policy = {
        retention_duration_seconds = 604800
      }

      # Cost optimization: Automatically move cold data to cheaper tiers
      autoclass = {
        enabled = true
      }

      # Cleanup: Keep only the 3 most recent versions of any object
      enable_lifecycle = true
      lifecycle_rules = [
        {
          action_type        = "Delete"
          num_newer_versions = 3
          is_live            = false
        }
      ]

      labels = {
        purpose = "general-storage"
        safety  = "high"
      }
    }
  }
}
