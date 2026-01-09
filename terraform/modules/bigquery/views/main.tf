# terraform/modules/bigquery/views/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_bigquery_table" "this" {
  project             = var.project_id
  dataset_id          = var.dataset_id
  table_id            = var.view_id
  friendly_name       = var.friendly_name
  description         = var.description
  labels              = var.labels
  resource_tags       = var.resource_tags
  max_staleness       = var.max_staleness
  expiration_time     = var.expiration_time
  deletion_protection = var.deletion_protection

  dynamic "view" {
    for_each = var.is_materialized_view ? [] : [1]
    content {
      query          = var.query
      use_legacy_sql = var.use_legacy_sql
    }
  }

  dynamic "materialized_view" {
    for_each = var.is_materialized_view ? [1] : []
    content {
      query               = var.query
      enable_refresh      = var.enable_refresh
      refresh_interval_ms = var.refresh_interval_ms
    }
  }
}
