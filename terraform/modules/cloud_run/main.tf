# terraform/modules/cloud_run/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# ==============================================================================
# Cloud Run Services
# ==============================================================================
resource "google_cloud_run_v2_service" "services" {
  for_each = var.services

  project     = var.project_id
  location    = var.region
  name        = each.key
  description = each.value.description
  ingress     = each.value.ingress
  labels      = var.labels

  custom_audiences = each.value.custom_audiences

  dynamic "binary_authorization" {
    for_each = each.value.binary_authorization != null ? [each.value.binary_authorization] : []
    content {
      use_default = binary_authorization.value.use_default
      policy      = binary_authorization.value.policy
    }
  }

  template {
    service_account                  = each.value.service_account
    timeout                          = each.value.timeout
    execution_environment            = each.value.execution_environment
    max_instance_request_concurrency = each.value.max_instance_request_concurrency

    containers {
      image = each.value.image

      resources {
        limits = {
          cpu    = each.value.cpu
          memory = each.value.memory
        }
        cpu_idle = each.value.cpu_idle
      }

      dynamic "env" {
        for_each = each.value.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "liveness_probe" {
        for_each = each.value.liveness_probe != null ? [each.value.liveness_probe] : []
        content {
          initial_delay_seconds = liveness_probe.value.initial_delay_seconds
          timeout_seconds       = liveness_probe.value.timeout_seconds
          period_seconds        = liveness_probe.value.period_seconds
          failure_threshold     = liveness_probe.value.failure_threshold
          dynamic "http_get" {
            for_each = liveness_probe.value.http_get != null ? [liveness_probe.value.http_get] : []
            content {
              path = http_get.value.path
              port = http_get.value.port
            }
          }
        }
      }

      dynamic "startup_probe" {
        for_each = each.value.startup_probe != null ? [each.value.startup_probe] : []
        content {
          initial_delay_seconds = startup_probe.value.initial_delay_seconds
          timeout_seconds       = startup_probe.value.timeout_seconds
          period_seconds        = startup_probe.value.period_seconds
          failure_threshold     = startup_probe.value.failure_threshold
          dynamic "http_get" {
            for_each = startup_probe.value.http_get != null ? [startup_probe.value.http_get] : []
            content {
              path = http_get.value.path
              port = http_get.value.port
            }
          }
        }
      }
    }

    dynamic "vpc_access" {
      for_each = each.value.vpc_connector != null ? [1] : []
      content {
        connector = each.value.vpc_connector
        egress    = "ALL_TRAFFIC"
      }
    }

    scaling {
      min_instance_count = each.value.min_instance_count
      max_instance_count = each.value.max_instance_count
    }
  }

  dynamic "traffic" {
    for_each = each.value.traffic
    content {
      percent  = traffic.value.percent
      type     = traffic.value.type
      revision = traffic.value.revision
      tag      = traffic.value.tag
    }
  }

  depends_on = [google_project_service.run]
}

# IAM Bindings for Invokers
resource "google_cloud_run_service_iam_binding" "invoker" {
  for_each = {
    for k, v in var.services : k => v
    if length(v.invoker_members != null ? v.invoker_members : []) > 0
  }

  project  = var.project_id
  location = var.region
  service  = google_cloud_run_v2_service.services[each.key].name
  role     = "roles/run.invoker"
  members  = each.value.invoker_members
}

# ==============================================================================
# Cloud Run Jobs
# ==============================================================================
resource "google_cloud_run_v2_job" "jobs" {
  for_each = var.jobs

  project  = var.project_id
  location = var.region
  name     = each.key
  labels   = var.labels

  template {
    template {
      service_account = each.value.service_account
      max_retries     = each.value.max_retries
      timeout         = each.value.timeout

      containers {
        image = each.value.image

        resources {
          limits = {
            cpu    = each.value.cpu
            memory = each.value.memory
          }
        }

        dynamic "env" {
          for_each = each.value.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }

      dynamic "vpc_access" {
        for_each = each.value.vpc_connector != null ? [1] : []
        content {
          connector = each.value.vpc_connector
          egress    = "ALL_TRAFFIC"
        }
      }
    }
  }

  depends_on = [google_project_service.run]
}
