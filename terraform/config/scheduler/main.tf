terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "scheduler" {
  source = "../../modules/scheduler"

  project_id = var.project_id
  region     = var.region

  create_app_engine          = false
  app_engine_service_account = "sa-scheduler@${var.project_id}.iam.gserviceaccount.com"

  scheduler_jobs = local.scheduler_jobs
}
