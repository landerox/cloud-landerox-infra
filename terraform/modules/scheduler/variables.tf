variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Default GCP region for scheduler jobs"
  type        = string
  default     = "us-central1"
}



variable "create_app_engine" {
  description = "Whether to create an App Engine application (required for Cloud Scheduler in some regions)"
  type        = bool
  default     = false
}

variable "app_engine_location" {
  description = "Location for App Engine application"
  type        = string
  default     = "us-central"
}

variable "app_engine_service_account" {
  description = "Service account to use for App Engine (required if default SA is deleted)"
  type        = string
  default     = ""
}

variable "scheduler_jobs" {
  description = "Map of Cloud Scheduler jobs to create"
  type = map(object({
    description = optional(string, "Managed by Terraform")
    schedule    = string # Cron expression (e.g., "0 9 * * 1" for every Monday at 9am)
    time_zone   = optional(string, "UTC")
    region      = optional(string)
    paused      = optional(bool, false)

    attempt_deadline = optional(string, "320s")

    retry_config = optional(object({
      retry_count          = optional(number, 0)
      max_retry_duration   = optional(string)
      min_backoff_duration = optional(string, "5s")
      max_backoff_duration = optional(string, "3600s")
      max_doublings        = optional(number, 5)
    }))

    # HTTP Target (mutually exclusive with pubsub_target and app_engine_target)
    http_target = optional(object({
      uri                   = string
      http_method           = optional(string, "POST")
      body                  = optional(string)
      headers               = optional(map(string))
      oauth_service_account = optional(string)
      oauth_scope           = optional(string)
      oidc_service_account  = optional(string)
      oidc_audience         = optional(string)
    }))

    # Pub/Sub Target (mutually exclusive with http_target and app_engine_target)
    pubsub_target = optional(object({
      topic_name = string
      data       = optional(string)
      attributes = optional(map(string))
    }))

    # App Engine Target (mutually exclusive with http_target and pubsub_target)
    app_engine_target = optional(object({
      http_method  = optional(string, "POST")
      relative_uri = string
      body         = optional(string)
      headers      = optional(map(string))
      service      = optional(string)
      version      = optional(string)
      instance     = optional(string)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, job in var.scheduler_jobs :
      (job.http_target != null ? 1 : 0) + (job.pubsub_target != null ? 1 : 0) + (job.app_engine_target != null ? 1 : 0) == 1
    ])
    error_message = "Each scheduler job must have exactly one target: http_target, pubsub_target, or app_engine_target."
  }
}
