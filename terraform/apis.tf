# =============================================================================
# GCP APIs Management
# =============================================================================
# This file manages the activation of GCP Services (APIs).
# Using Terraform ensures that required APIs are always enabled and versioned.

locals {
  services = [
    "artifactregistry.googleapis.com",     # Container Registry
    "bigquery.googleapis.com",             # BigQuery
    "cloudbuild.googleapis.com",           # Cloud Build
    "cloudfunctions.googleapis.com",       # Cloud Functions
    "cloudresourcemanager.googleapis.com", # Project and Resource Management
    "cloudscheduler.googleapis.com",       # Cron Jobs
    "cloudtrace.googleapis.com",           # Required by Cloud Scheduler
    "iam.googleapis.com",                  # Identity and Access Management
    "iamcredentials.googleapis.com",       # Required for WIF and impersonation
    "logging.googleapis.com",              # Stackdriver Logging
    "monitoring.googleapis.com",           # Stackdriver Monitoring
    "run.googleapis.com",                  # Cloud Run & Cloud Functions v2
    "secretmanager.googleapis.com",        # Secrets Management
    "serviceusage.googleapis.com",         # Enable/Disable APIs
    "storage.googleapis.com",              # Google Cloud Storage
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.services)
  project  = var.project_id
  service  = each.key

  # Set to false to prevent accidental disabling of critical services
  # if the resource is removed from Terraform state.
  disable_on_destroy = false
}
