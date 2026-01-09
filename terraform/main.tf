# =============================================================================
# Template GCP - Root Module
# =============================================================================
#
# This module orchestrates all child modules using configuration from:
#   - terraform.tfvars: Environment-specific values (project_id, region, etc.)
#   - config/*.tfvars: Resource definitions (buckets, service accounts, etc.)
#
# Resource definitions in config/*.tfvars are version-controlled and deployed
# through CI/CD with manual approval.
#
# =============================================================================

# -----------------------------------------------------------------------------
# IAM Module
# -----------------------------------------------------------------------------
# Manages Service Accounts and IAM bindings.

module "iam" {
  count  = var.enable_iam_module ? 1 : 0
  source = "./config/iam"

  project_id                         = var.project_id
  repository_id                      = var.repository_id
  wif_repos                          = var.wif_repositories
  workload_identity_pool_id          = var.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
}

# -----------------------------------------------------------------------------
# Propagation Delay
# -----------------------------------------------------------------------------
# Waits for IAM permissions to propagate before creating dependent resources.
# This prevents race conditions with App Engine creation.
resource "time_sleep" "wait_for_iam" {
  depends_on      = [module.iam]
  create_duration = "60s"
}

# -----------------------------------------------------------------------------
# Storage Module
# -----------------------------------------------------------------------------
# Creates GCS buckets using the configuration defined in the template module.
# To add more buckets, see the config/storage directory.

module "storage" {
  count  = var.enable_storage_module ? 1 : 0
  source = "./config/storage"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  labels      = local.all_labels
}

# -----------------------------------------------------------------------------
# BigQuery Module
# -----------------------------------------------------------------------------
# Manages Datasets, Tables, Views, and Scheduled Queries.

module "bigquery_datasets" {
  count  = var.enable_bigquery_module ? 1 : 0
  source = "./config/bigquery/datasets"

  project_id = var.project_id
  location   = var.region
  labels     = local.all_labels

  depends_on = [google_project_service.apis]
}

# -----------------------------------------------------------------------------
# Secret Manager Module
# -----------------------------------------------------------------------------
# Manages Secrets and versions.

module "secrets" {
  count  = var.enable_secrets_module ? 1 : 0
  source = "./config/secrets"

  project_id = var.project_id
  region     = var.region
  labels     = local.all_labels
}

# -----------------------------------------------------------------------------
# Cloud Scheduler Module
# -----------------------------------------------------------------------------
# Manages Cron jobs.

module "scheduler" {
  count  = var.enable_scheduler_module ? 1 : 0
  source = "./config/scheduler"

  project_id = var.project_id
  region     = var.region

  depends_on = [time_sleep.wait_for_iam, google_project_service.apis]
}

# -----------------------------------------------------------------------------
# Artifact Registry Module
# -----------------------------------------------------------------------------
# Manages Container Images and Packages.

module "artifact_registry" {
  count  = var.enable_artifact_registry_module ? 1 : 0
  source = "./config/artifact_registry"

  project_id = var.project_id
  region     = var.region
  labels     = local.all_labels
}

# -----------------------------------------------------------------------------
# Cloud Run Module
# -----------------------------------------------------------------------------
# Manages Cloud Run services (and V2 Functions).
module "cloud_run" {
  count  = var.enable_cloud_run_module ? 1 : 0
  source = "./config/cloud_run"

  project_id = var.project_id
  region     = var.region

}
