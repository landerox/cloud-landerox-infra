# =============================================================================
# Google Cloud Provider Configuration
# =============================================================================
#
# Provider versions are defined in versions.tf
# Authentication is handled via:
#   - Local: gcloud auth application-default login
#   - CI/CD: Workload Identity Federation (WIF)
#
# =============================================================================

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
