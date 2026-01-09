# =============================================================================
# PRD Environment Configuration
# =============================================================================
# Non-sensitive configuration for the production environment.
# This file is automatically loaded by the CI/CD pipeline.

# === Governance ===
owner = "landerox"

# === Module Toggles ===
enable_iam_module               = true
enable_storage_module           = true
enable_artifact_registry_module = false
enable_cloud_run_module         = false
enable_secrets_module           = false
enable_scheduler_module         = false
enable_bigquery_module          = false

# === WIF Authorized Repositories ===
wif_repositories = [
  {
    repo            = "landerox/cloud-landerox-data"
    service_account = "sa-deployment"
  }
]
