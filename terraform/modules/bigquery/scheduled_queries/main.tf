# terraform/modules/bigquery/scheduled_queries/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_bigquery_data_transfer_config" "this" {
  project                = var.project_id
  location               = var.location
  display_name           = var.display_name
  data_source_id         = "scheduled_query"
  destination_dataset_id = var.destination_dataset_id
  schedule               = var.schedule
  disabled               = var.disabled

  params = {
    query                           = var.query
    destination_table_name_template = var.destination_table_name_template
    write_disposition               = var.write_disposition
  }

  service_account_name      = var.service_account_name
  notification_pubsub_topic = var.notification_pubsub_topic
  data_refresh_window_days  = var.data_refresh_window_days

  dynamic "schedule_options" {
    for_each = var.schedule_options != null ? [var.schedule_options] : []
    content {
      start_time = schedule_options.value.start_time
      end_time   = schedule_options.value.end_time
    }
  }

  dynamic "email_preferences" {
    for_each = var.email_preferences != null ? [var.email_preferences] : []
    content {
      enable_failure_email = email_preferences.value.enable_failure_email
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_name = encryption_configuration.value.kms_key_name
    }
  }
}
