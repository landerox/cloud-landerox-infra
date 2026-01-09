# terraform/modules/bigquery/datasets/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_bigquery_dataset" "this" {
  project                         = var.project_id
  dataset_id                      = var.dataset_id
  friendly_name                   = var.friendly_name
  description                     = var.description
  location                        = var.location
  labels                          = var.labels
  resource_tags                   = var.resource_tags
  delete_contents_on_destroy      = var.delete_contents_on_destroy
  default_table_expiration_ms     = var.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms
  max_time_travel_hours           = var.max_time_travel_hours
  is_case_insensitive             = var.is_case_insensitive
  storage_billing_model           = var.storage_billing_model

  dynamic "default_encryption_configuration" {
    for_each = var.default_encryption_configuration != null ? [var.default_encryption_configuration] : []
    content {
      kms_key_name = default_encryption_configuration.value.kms_key_name
    }
  }

  dynamic "access" {
    for_each = var.access != null ? var.access : []
    content {
      role           = access.value.role
      user_by_email  = access.value.user_by_email
      group_by_email = access.value.group_by_email
      domain         = access.value.domain
      special_group  = access.value.special_group
      iam_member     = access.value.iam_member

      dynamic "dataset" {
        for_each = access.value.dataset != null ? [access.value.dataset] : []
        content {
          dataset {
            dataset_id = dataset.value.dataset_id
            project_id = dataset.value.project_id
          }
          target_types = dataset.value.target_types
        }
      }

      dynamic "routine" {
        for_each = access.value.routine != null ? [access.value.routine] : []
        content {
          dataset_id = routine.value.dataset_id
          project_id = routine.value.project_id
          routine_id = routine.value.routine_id
        }
      }

      dynamic "view" {
        for_each = access.value.view != null ? [access.value.view] : []
        content {
          dataset_id = view.value.dataset_id
          project_id = view.value.project_id
          table_id   = view.value.view_id
        }
      }
    }
  }
}
