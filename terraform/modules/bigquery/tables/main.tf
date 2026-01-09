# terraform/modules/bigquery/tables/main.tf

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
  project                  = var.project_id
  dataset_id               = var.dataset_id
  table_id                 = var.table_id
  friendly_name            = var.friendly_name
  description              = var.description
  labels                   = var.labels
  resource_tags            = var.resource_tags
  deletion_protection      = var.deletion_protection
  expiration_time          = var.expiration_time
  max_staleness            = var.max_staleness
  schema                   = var.schema_path != null ? file(var.schema_path) : null
  clustering               = var.clustering_fields
  require_partition_filter = var.require_partition_filter

  dynamic "time_partitioning" {
    for_each = var.partition_type != null ? [1] : []
    content {
      type          = var.partition_type
      field         = var.partition_field
      expiration_ms = var.partition_expiration_ms
    }
  }

  dynamic "range_partitioning" {
    for_each = var.range_partitioning != null ? [var.range_partitioning] : []
    content {
      field = range_partitioning.value.field
      range {
        start    = range_partitioning.value.range.start
        end      = range_partitioning.value.range.end
        interval = range_partitioning.value.range.interval
      }
    }
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_name = encryption_configuration.value.kms_key_name
    }
  }

  dynamic "table_constraints" {
    for_each = var.table_constraints != null ? [var.table_constraints] : []
    content {
      dynamic "primary_key" {
        for_each = table_constraints.value.primary_key != null ? [table_constraints.value.primary_key] : []
        content {
          columns = primary_key.value.columns
        }
      }
      dynamic "foreign_keys" {
        for_each = table_constraints.value.foreign_keys != null ? table_constraints.value.foreign_keys : []
        content {
          name = foreign_keys.value.name
          referenced_table {
            project_id = foreign_keys.value.referenced_table.project_id
            dataset_id = foreign_keys.value.referenced_table.dataset_id
            table_id   = foreign_keys.value.referenced_table.table_id
          }
          dynamic "column_references" {
            for_each = foreign_keys.value.column_references
            content {
              referenced_column  = column_references.value.referenced_column
              referencing_column = column_references.value.referencing_column
            }
          }
        }
      }
    }
  }

  dynamic "external_data_configuration" {
    for_each = var.external_data_configuration != null ? [var.external_data_configuration] : []
    content {
      autodetect    = external_data_configuration.value.autodetect
      source_format = external_data_configuration.value.source_format
      source_uris   = external_data_configuration.value.source_uris
      compression   = external_data_configuration.value.compression
      connection_id = external_data_configuration.value.connection_id

      dynamic "csv_options" {
        for_each = external_data_configuration.value.csv_options != null ? [external_data_configuration.value.csv_options] : []
        content {
          quote                 = csv_options.value.quote
          allow_jagged_rows     = csv_options.value.allow_jagged_rows
          allow_quoted_newlines = csv_options.value.allow_quoted_newlines
          encoding              = csv_options.value.encoding
          field_delimiter       = csv_options.value.field_delimiter
          skip_leading_rows     = csv_options.value.skip_leading_rows
        }
      }

      dynamic "google_sheets_options" {
        for_each = external_data_configuration.value.google_sheets_options != null ? [external_data_configuration.value.google_sheets_options] : []
        content {
          range             = google_sheets_options.value.range
          skip_leading_rows = google_sheets_options.value.skip_leading_rows
        }
      }

      dynamic "hive_partitioning_options" {
        for_each = external_data_configuration.value.hive_partitioning_options != null ? [external_data_configuration.value.hive_partitioning_options] : []
        content {
          mode              = hive_partitioning_options.value.mode
          source_uri_prefix = hive_partitioning_options.value.source_uri_prefix
        }
      }
    }
  }

  dynamic "biglake_configuration" {
    for_each = var.biglake_configuration != null ? [var.biglake_configuration] : []
    content {
      connection_id = biglake_configuration.value.connection_id
      storage_uri   = biglake_configuration.value.storage_uri
      file_format   = biglake_configuration.value.source_format
      table_format  = biglake_configuration.value.table_format
    }
  }
}
