locals {
  service_accounts = {
    # ===========================================================================
    # SERVICE ACCOUNT CONFIGURATION
    # ===========================================================================
    # Define your service accounts here.
    #
    # TEMPLATE:
    # "sa-name" = {
    #   display_name = "Human readable name"
    #   description  = "Purpose of this identity"
    #   disabled     = false # (Optional)
    #   roles        = ["roles/viewer"] # (Optional)
    #   impersonation_users = ["user:email@example.com"] # (Optional)
    # }

    "sa-terraform" = {
      display_name = "Terraform CI/CD Service Account"
      description  = "Managed by Terraform - Used by GitHub Actions for CI/CD"
      roles = [
        "roles/appengine.appCreator",           # Required to initialize App Engine (one-time)
        "roles/artifactregistry.admin",         # Full control over Artifact Registry
        "roles/bigquery.admin",                 # Full control over BigQuery
        "roles/cloudscheduler.admin",           # Full control over Scheduler
        "roles/editor",                         # General resource management
        "roles/iam.securityAdmin",              # Required to manage IAM bindings
        "roles/iam.serviceAccountUser",         # Required to assign a user-managed SA to App Engine
        "roles/secretmanager.admin",            # Full control over Secrets
        "roles/serviceusage.serviceUsageAdmin", # Allows the SA to enable/disable APIs
        "roles/storage.admin",                  # Full control over GCS
      ]
    }

    "sa-deployment" = {
      display_name = "Deployment Service Account"
      description  = "Used by CI/CD to deploy Cloud Functions, Dataflow jobs and other data resources"
      roles = [
        "roles/artifactregistry.writer",
        "roles/bigquery.dataEditor",
        "roles/cloudbuild.builds.builder",
        "roles/cloudfunctions.developer",
        "roles/compute.instanceAdmin.v1",
        "roles/dataflow.developer",
        "roles/iam.serviceAccountUser",
        "roles/logging.logWriter",
        "roles/pubsub.editor",
        "roles/run.admin",
        "roles/storage.objectAdmin",
      ]
    }

    "sa-dataflow" = {
      display_name = "Dataflow Runtime SA"
      description  = "Identity for Dataflow workers execution"
      roles = [
        "roles/artifactregistry.reader",
        "roles/bigquery.dataEditor",
        "roles/bigquery.jobUser",
        "roles/dataflow.worker",
        "roles/logging.logWriter",
        "roles/pubsub.editor",
        "roles/storage.objectAdmin",
      ]
    }

    "sa-functions" = {
      display_name = "Cloud Functions Runtime SA"
      description  = "Identity for Cloud Functions execution"
      roles = [
        "roles/artifactregistry.reader",
        "roles/bigquery.dataEditor",
        "roles/bigquery.jobUser",
        "roles/logging.logWriter",
        "roles/storage.objectUser",
      ]
    }

    "sa-scheduler" = {
      display_name = "Cloud Scheduler Service Account"
      description  = "Identity for Cloud Scheduler execution"
      roles = [
        "roles/logging.logWriter",
        "roles/run.invoker",
        "roles/storage.objectUser",
      ]
      impersonation_users = [
        "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudscheduler.iam.gserviceaccount.com"
      ]
    }
  }
}
