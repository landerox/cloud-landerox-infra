locals {
  repositories = {
    # "${var.project_id}-gcf-artifacts" = {
    #   description   = "Docker repository for Cloud Functions images"
    #   format        = "DOCKER"
    #   mode          = "STANDARD_REPOSITORY"
    #   immutable_tags = false # Allows overwriting 'latest'

    #   # --- Cleanup Policy ---
    #   # Keep only the last 5 versions tagged 'latest' or 'release-*'
    #   # Delete untagged images older than 7 days
    #   cleanup_policies = [
    #     {
    #       id     = "keep-tagged-versions"
    #       action = "KEEP"
    #       condition = {
    #         tag_state    = "TAGGED"
    #         tag_prefixes = ["latest", "release", "v"]
    #         newer_than   = "2592000s" # 30 days
    #       }
    #     },
    #     {
    #       id     = "delete-old-untagged"
    #       action = "DELETE"
    #       condition = {
    #         tag_state  = "UNTAGGED"
    #         older_than = "604800s" # 7 days
    #       }
    #     }
    #   ]

    #   labels = {
    #     purpose = "serverless-images"
    #     managed = "terraform"
    #   }
    # }
  }
}
