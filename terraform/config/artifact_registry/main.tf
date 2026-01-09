terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "artifact_registry" {
  source = "../../modules/artifact_registry"

  project_id = var.project_id
  location   = var.region
  labels     = var.labels

  repositories = local.repositories
}
