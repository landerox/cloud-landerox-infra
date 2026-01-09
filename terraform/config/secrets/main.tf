terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "secrets" {
  source = "../../modules/secrets"

  project_id = var.project_id
  region     = var.region
  labels     = var.labels

  secrets = local.secrets
}
