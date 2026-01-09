# terraform/modules/secrets/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "secrets" {
  for_each = var.secrets

  project   = var.project_id
  secret_id = each.key

  labels = merge(
    var.labels,
    each.value.labels != null ? each.value.labels : {},
    {
      secret_name = each.key
    }
  )

  annotations     = each.value.annotations
  expire_time     = each.value.expire_time
  ttl             = each.value.ttl
  version_aliases = each.value.version_aliases

  replication {
    dynamic "auto" {
      for_each = each.value.replication_type == "auto" ? [1] : []
      content {
        dynamic "customer_managed_encryption" {
          for_each = each.value.kms_key_name != null ? [1] : []
          content {
            kms_key_name = each.value.kms_key_name
          }
        }
      }
    }

    dynamic "user_managed" {
      for_each = each.value.replication_type == "user_managed" ? [1] : []
      content {
        dynamic "replicas" {
          for_each = each.value.replica_locations != null ? each.value.replica_locations : [var.region]
          content {
            location = replicas.value
            dynamic "customer_managed_encryption" {
              for_each = each.value.kms_key_name != null ? [1] : []
              content {
                kms_key_name = each.value.kms_key_name
              }
            }
          }
        }
      }
    }
  }

  dynamic "rotation" {
    for_each = each.value.rotation_period != null ? [1] : []
    content {
      rotation_period    = each.value.rotation_period
      next_rotation_time = each.value.next_rotation_time
    }
  }

  dynamic "topics" {
    for_each = each.value.pubsub_topic != null ? [each.value.pubsub_topic] : []
    content {
      name = topics.value
    }
  }

  depends_on = [google_project_service.secretmanager]
}

# Create initial secret version if value is provided
resource "google_secret_manager_secret_version" "versions" {
  for_each = {
    for name, config in var.secrets : name => config
    if config.initial_value != null
  }

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.initial_value

  lifecycle {
    ignore_changes = [secret_data]
  }
}

# Grant access to secrets
resource "google_secret_manager_secret_iam_member" "accessors" {
  for_each = {
    for binding in local.secret_bindings : "${binding.secret}-${binding.role}-${binding.member}" => binding
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret].secret_id
  role      = each.value.role
  member    = each.value.member
}

locals {
  secret_bindings = flatten([
    for secret_name, secret_config in var.secrets : [
      for accessor in(secret_config.accessors != null ? secret_config.accessors : []) : {
        secret = secret_name
        role   = "roles/secretmanager.secretAccessor"
        member = accessor
      }
    ]
  ])
}
