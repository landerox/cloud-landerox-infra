terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "storage_buckets" {
  source = "../../modules/storage"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  labels      = var.labels
  buckets     = local.buckets
}
