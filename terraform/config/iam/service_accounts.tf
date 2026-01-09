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
        "roles/editor",                         # General resource management
        "roles/iam.securityAdmin",              # Required to manage IAM bindings
        "roles/storage.admin",                  # Full control over GCS
        "roles/secretmanager.admin",            # Full control over Secrets
        "roles/artifactregistry.admin",         # Full control over Artifact Registry
        "roles/serviceusage.serviceUsageAdmin", # Allows the SA to enable/disable APIs
        "roles/cloudscheduler.admin",           # Full control over Scheduler
        "roles/appengine.appCreator",           # Required to initialize App Engine (one-time)
        "roles/iam.serviceAccountUser",         # Required to assign a user-managed SA to App Engine
        "roles/bigquery.admin",                 # Full control over BigQuery
      ]
    }

    "sa-deployment" = {
      display_name = "Cloud Functions Deployment SA"
      description  = "Used by CI/CD to deploy Cloud Functions"
      roles = [
        "roles/cloudfunctions.developer",
        "roles/iam.serviceAccountUser",
        "roles/artifactregistry.writer",
        "roles/storage.objectAdmin",
        "roles/logging.logWriter",
        "roles/cloudbuild.builds.builder",
        "roles/run.admin",
      ]
    }

    "sa-functions" = {
      display_name = "Cloud Functions Runtime SA"
      description  = "Identity for Cloud Functions execution"
      roles = [
        "roles/logging.logWriter",
        "roles/artifactregistry.reader",
        "roles/storage.objectUser",
        "roles/bigquery.dataEditor",
        "roles/bigquery.jobUser",
      ]
    }

    "sa-scheduler" = {
      display_name = "Cloud Scheduler Service Account"
      description  = "Identity for Cloud Scheduler execution"
      roles = [
        "roles/run.invoker",
        "roles/logging.logWriter",
        "roles/storage.objectUser",
      ]
      impersonation_users = [
        "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudscheduler.iam.gserviceaccount.com"
      ]
    }
  }
}
