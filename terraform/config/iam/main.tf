terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

data "google_project" "project" {
  project_id = var.project_id
}

module "iam_service_accounts" {
  source = "../../modules/iam"

  project_id                         = var.project_id
  repository_id                      = var.repository_id
  workload_identity_pool_id          = var.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
  service_accounts                   = local.service_accounts
  custom_roles                       = local.custom_roles
  project_iam_bindings               = local.project_iam_bindings

  wif_repositories = var.wif_repos
}
