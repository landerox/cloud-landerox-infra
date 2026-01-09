# terraform/modules/scheduler/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
#
# Creates and manages Cloud Scheduler jobs for automated task execution.
# Supports HTTP, Pub/Sub, and App Engine targets.
#
# =============================================================================

resource "google_project_service" "cloudscheduler" {
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "appengine" {
  count              = var.create_app_engine ? 1 : 0
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}

# App Engine application creation via gcloud (native resource doesn't support service_account)
resource "null_resource" "app_engine_create" {
  count = var.create_app_engine ? 1 : 0

  triggers = {
    project = var.project_id
    region  = var.app_engine_location
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud app create --region=${var.app_engine_location} --service-account=${var.app_engine_service_account} --project=${var.project_id} --quiet || true
    EOT
  }

  depends_on = [google_project_service.appengine]
}

resource "google_cloud_scheduler_job" "jobs" {
  for_each = var.scheduler_jobs

  project     = var.project_id
  region      = each.value.region != null ? each.value.region : var.region
  name        = each.key
  description = each.value.description
  schedule    = each.value.schedule
  time_zone   = each.value.time_zone != null ? each.value.time_zone : "UTC"

  paused = each.value.paused != null ? each.value.paused : false

  attempt_deadline = each.value.attempt_deadline != null ? each.value.attempt_deadline : "320s"

  dynamic "retry_config" {
    for_each = each.value.retry_config != null ? [each.value.retry_config] : []
    content {
      retry_count          = retry_config.value.retry_count
      max_retry_duration   = retry_config.value.max_retry_duration
      min_backoff_duration = retry_config.value.min_backoff_duration
      max_backoff_duration = retry_config.value.max_backoff_duration
      max_doublings        = retry_config.value.max_doublings
    }
  }

  # HTTP Target
  dynamic "http_target" {
    for_each = each.value.http_target != null ? [each.value.http_target] : []
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method != null ? http_target.value.http_method : "POST"
      body        = http_target.value.body != null ? base64encode(http_target.value.body) : null
      headers     = http_target.value.headers

      dynamic "oauth_token" {
        for_each = http_target.value.oauth_service_account != null ? [1] : []
        content {
          service_account_email = http_target.value.oauth_service_account
          scope                 = http_target.value.oauth_scope
        }
      }

      dynamic "oidc_token" {
        for_each = http_target.value.oidc_service_account != null ? [1] : []
        content {
          service_account_email = http_target.value.oidc_service_account
          audience              = http_target.value.oidc_audience
        }
      }
    }
  }

  # Pub/Sub Target
  dynamic "pubsub_target" {
    for_each = each.value.pubsub_target != null ? [each.value.pubsub_target] : []
    content {
      topic_name = pubsub_target.value.topic_name
      data       = pubsub_target.value.data != null ? base64encode(pubsub_target.value.data) : null
      attributes = pubsub_target.value.attributes
    }
  }

  # App Engine HTTP Target
  dynamic "app_engine_http_target" {
    for_each = each.value.app_engine_target != null ? [each.value.app_engine_target] : []
    content {
      http_method  = app_engine_http_target.value.http_method != null ? app_engine_http_target.value.http_method : "POST"
      relative_uri = app_engine_http_target.value.relative_uri
      body         = app_engine_http_target.value.body != null ? base64encode(app_engine_http_target.value.body) : null
      headers      = app_engine_http_target.value.headers

      dynamic "app_engine_routing" {
        for_each = app_engine_http_target.value.service != null ? [1] : []
        content {
          service  = app_engine_http_target.value.service
          version  = app_engine_http_target.value.version
          instance = app_engine_http_target.value.instance
        }
      }
    }
  }

  depends_on = [
    google_project_service.cloudscheduler,
    null_resource.app_engine_create
  ]
}
