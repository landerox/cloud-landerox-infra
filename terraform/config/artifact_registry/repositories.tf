locals {
  repositories = {
    # ===========================================================================
    # DOCKER REPOSITORIES
    # ===========================================================================
    "${var.project_id}-artifacts" = {
      description = "Main Docker repository for Cloud Functions and other artifacts"
      format      = "DOCKER"
      mode        = "STANDARD_REPOSITORY"

      # --- Cleanup Policies ---
      cleanup_policies = {
        # Keep the 3 most recent versions of any package
        "keep-recent-versions" = {
          action = "KEEP"
          most_recent_versions = {
            keep_count = 3
          }
        }
        # Delete images older than 7 days if they are not part of the most recent ones
        "delete-old-images" = {
          action = "DELETE"
          condition = {
            older_than = "604800s" # 7 days in seconds
          }
        }
      }

      labels = {
        purpose = "serverless-images"
        team    = "platform"
        managed = "terraform"
      }
    }
  }
}
