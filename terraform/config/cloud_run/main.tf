terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id = var.project_id
  region     = var.region
  labels     = var.labels

  services = local.cloud_run_services
  jobs     = local.cloud_run_jobs
}
