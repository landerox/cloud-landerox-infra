locals {
  scheduler_jobs = {
    # ===========================================================================
    # CLOUD SCHEDULER JOBS
    # ===========================================================================
    # Define your jobs here.
    # Use the TEMPLATE below.

    # ===========================================================================
    # TEMPLATE: Advanced HTTP Job
    # ===========================================================================
    # "daily-report-trigger" = {
    #   description = "Triggers the reporting service every day at 6 AM UTC"
    #   schedule    = "0 6 * * *" # Cron format
    #   time_zone   = "UTC"       # Examples: "America/Santiago", "Europe/London"
    #   paused      = false       # Set to true to disable without deleting
    #
    #   # --- Robustness ---
    #   attempt_deadline = "600s" # Max time the job can run
    #   retry_config = {
    #     retry_count          = 3
    #     max_retry_duration   = "0s"  # 0s = Unlimited duration within retry count
    #     min_backoff_duration = "5s"
    #     max_backoff_duration = "3600s"
    #     max_doublings        = 5
    #   }
    #
    #   # --- Target: HTTP (Cloud Run / Functions) ---
    #   http_target = {
    #     uri                  = "https://my-service-xyz.a.run.app/jobs/report"
    #     http_method          = "POST"
    #     body                 = "eyJmb28iOiJiYXIifQ==" # Base64 encoded: {"foo":"bar"}
    #     headers = {
    #       "Content-Type" = "application/json"
    #       "X-Source"     = "CloudScheduler"
    #     }
    #     # Authentication (OIDC is standard for Cloud Run/Functions)
    #     oidc_service_account = "sa-scheduler@${var.project_id}.iam.gserviceaccount.com"
    #     oidc_audience        = "https://my-service-xyz.a.run.app/"
    #   }
    # }

    # ===========================================================================
    # TEMPLATE: Pub/Sub Job
    # ===========================================================================
    # "hourly-cleanup-event" = {
    #   description = "Publishes a cleanup event every hour"
    #   schedule    = "0 * * * *"
    #   time_zone   = "UTC"
    #
    #   pubsub_target = {
    #     topic_name = "projects/${var.project_id}/topics/cleanup-topic"
    #     data       = "e30=" # Base64 encoded: {}
    #     attributes = {
    #       severity = "low"
    #     }
    #   }
    # }
  }
}
