locals {
  datasets = {
    # ===========================================================================
    # BIGQUERY DATASETS
    # ===========================================================================
    # Define your datasets here.
    # Use the TEMPLATE below for advanced configuration.

    # ===========================================================================
    # TEMPLATE: Advanced Dataset
    # ===========================================================================
    # "dataset_id" = {
    #   friendly_name               = "My Advanced Dataset"
    #   description                 = "Description of the data purpose"
    #   location                    = "us-central1" # Default: var.location
    #
    #   # --- Governance & Retention ---
    #   delete_contents_on_destroy  = false # Set to true ONLY for ephemeral data
    #   max_time_travel_hours       = 168   # Range: 48 to 168 (7 days)
    #   is_case_insensitive         = true
    #
    #   # --- Billing ---
    #   storage_billing_model       = "LOGICAL" # Options: [LOGICAL, PHYSICAL]
    #
    #   # --- Expiration ---
    #   default_table_expiration_ms     = 3600000 # 1 hour
    #   default_partition_expiration_ms = null
    #
    #   # --- Labels & Tags ---
    #   labels = {
    #     env      = "prd"
    #     security = "high"
    #   }
    #   resource_tags = {
    #     "tagKeys/123" = "tagValues/456"
    #   }
    # }
  }
}
