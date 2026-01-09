# terraform/modules/storage/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  project  = var.project_id
  name     = each.key
  location = each.value.location != null ? each.value.location : var.region

  storage_class               = each.value.storage_class != null ? each.value.storage_class : "STANDARD"
  uniform_bucket_level_access = each.value.uniform_access != null ? each.value.uniform_access : true

  versioning {
    enabled = each.value.versioning_enabled != null ? each.value.versioning_enabled : false
  }

  dynamic "logging" {
    for_each = each.value.enable_logging != null && each.value.enable_logging ? [1] : []
    content {
      log_bucket = google_storage_bucket.log_bucket[each.key].id
    }
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.enable_lifecycle != null && each.value.enable_lifecycle ? (each.value.lifecycle_rules != null ? each.value.lifecycle_rules : []) : []
    content {
      action {
        type          = lifecycle_rule.value.action_type
        storage_class = lifecycle_rule.value.action_storage_class
      }
      condition {
        age                        = lifecycle_rule.value.age_days
        matches_storage_class      = lifecycle_rule.value.matches_storage_class
        num_newer_versions         = lifecycle_rule.value.num_newer_versions
        days_since_noncurrent_time = lifecycle_rule.value.days_since_noncurrent_time
        with_state                 = lifecycle_rule.value.is_live != null ? (lifecycle_rule.value.is_live ? "LIVE" : "ARCHIVED") : null
      }
    }
  }

  public_access_prevention = each.value.public_access_prevention != null ? each.value.public_access_prevention : "enforced"

  dynamic "encryption" {
    for_each = each.value.encryption != null ? [each.value.encryption] : []
    content {
      default_kms_key_name = encryption.value.default_kms_key_name
    }
  }

  dynamic "retention_policy" {
    for_each = each.value.retention_policy != null ? [each.value.retention_policy] : []
    content {
      retention_period = retention_policy.value.retention_period
      is_locked        = retention_policy.value.is_locked
    }
  }

  dynamic "cors" {
    for_each = each.value.cors != null ? each.value.cors : []
    content {
      origin          = cors.value.origin
      method          = cors.value.method
      response_header = cors.value.response_header
      max_age_seconds = cors.value.max_age_seconds
    }
  }

  dynamic "soft_delete_policy" {
    for_each = each.value.soft_delete_policy != null ? [each.value.soft_delete_policy] : []
    content {
      retention_duration_seconds = soft_delete_policy.value.retention_duration_seconds
    }
  }

  dynamic "autoclass" {
    for_each = each.value.autoclass != null ? [each.value.autoclass] : []
    content {
      enabled                = autoclass.value.enabled
      terminal_storage_class = autoclass.value.terminal_storage_class
    }
  }

  dynamic "hierarchical_namespace" {
    for_each = each.value.hierarchical_namespace != null ? [each.value.hierarchical_namespace] : []
    content {
      enabled = hierarchical_namespace.value.enabled
    }
  }

  dynamic "custom_placement_config" {
    for_each = each.value.custom_placement_config != null ? [each.value.custom_placement_config] : []
    content {
      data_locations = custom_placement_config.value.data_locations
    }
  }

  dynamic "website" {
    for_each = each.value.website != null ? [each.value.website] : []
    content {
      main_page_suffix = website.value.main_page_suffix
      not_found_page   = website.value.not_found_page
    }
  }

  labels = merge(
    var.labels,
    each.value.labels != null ? each.value.labels : {},
    {
      bucket      = each.key
      environment = var.environment
    }
  )

  depends_on = [google_project_service.storage]
}

resource "google_storage_bucket" "log_bucket" {
  for_each = {
    for name, bucket in var.buckets : name => bucket
    if bucket.enable_logging != null && bucket.enable_logging
  }

  project  = var.project_id
  name     = "${each.key}-logs"
  location = each.value.location != null ? each.value.location : var.region

  storage_class = "STANDARD"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }

  labels = merge(
    var.labels,
    {
      bucket      = "${each.key}-logs"
      environment = var.environment
      purpose     = "access-logs"
    }
  )

  depends_on = [google_project_service.storage]
}

resource "google_project_service" "storage" {
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}
