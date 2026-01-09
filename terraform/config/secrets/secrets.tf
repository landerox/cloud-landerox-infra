locals {
  secrets = {
    # ===========================================================================
    # RESOURCE CONFIGURATION
    # ===========================================================================
    # Define your resources here.
    # Use the TEMPLATE below.

    # "active-secret-id" = {
    #   ... real configuration ...
    # }

    # ===========================================================================
    # TEMPLATE: Secret Definition
    # ===========================================================================
    # "dummy-secret-id" = {
    #   # --- Replication & Encryption ---
    #   replication_type   = "auto"        # (Optional) Options: [auto, user_managed]. Default: "auto"
    #   replica_locations  = []            # (Optional) List of regions. Required if replication_type="user_managed".
    #   kms_key_name       = ""            # (Optional) Cloud KMS key name for CMEK encryption.
    #
    #   # --- Rotation ---
    #   rotation_period    = "86400s"      # (Optional) Rotation frequency (e.g., "7776000s" = 90 days).
    #   next_rotation_time = ""            # (Optional) Timestamp for first rotation (RFC3339).
    #   pubsub_topic       = ""            # (Optional) Topic for rotation notifications.
    #
    #   # --- Lifecycle (Provider 7.x) ---
    #   expire_time        = "2025-12-31T23:59:59Z" # (Optional) Secret automatic deletion time.
    #   ttl                = "3600s"                # (Optional) Time to live.
    #
    #   # --- Access Control ---
    #   accessors = [                      # (Optional) List of IAM members to grant secret accessor role.
    #     "serviceAccount:sa-name@project.iam.gserviceaccount.com",
    #     "group:dev-team@example.com"
    #   ]
    #
    #   # --- Metadata ---
    #   labels = {                         # (Optional) Resource labels.
    #     "env" = "dev"
    #   }
    #   version_aliases = {                # (Optional) Custom aliases for versions.
    #     "prd" = "1"
    #   }
    #   initial_value = "dummy"            # (Optional) Initial value. Ignored after creation.
    # }
  }
}
