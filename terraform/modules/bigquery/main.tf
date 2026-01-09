terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "datasets" {
  source   = "./datasets"
  for_each = var.bigquery_datasets

  project_id                 = var.project_id
  dataset_id                 = each.key
  friendly_name              = try(each.value.friendly_name, null)
  description                = try(each.value.description, null)
  location                   = try(each.value.location, null)
  labels                     = merge(var.labels, try(each.value.labels, {}))
  resource_tags              = try(each.value.resource_tags, null)
  delete_contents_on_destroy = try(each.value.delete_contents_on_destroy, false)

  default_table_expiration_ms      = try(each.value.default_table_expiration_ms, null)
  default_partition_expiration_ms  = try(each.value.default_partition_expiration_ms, null)
  max_time_travel_hours            = try(each.value.max_time_travel_hours, null)
  is_case_insensitive              = try(each.value.is_case_insensitive, null)
  storage_billing_model            = try(each.value.storage_billing_model, null)
  default_encryption_configuration = try(each.value.default_encryption_configuration, null)
  access                           = try(each.value.access, null)
}

module "tables" {
  source   = "./tables"
  for_each = var.bigquery_tables

  project_id                  = var.project_id
  dataset_id                  = each.value.dataset_id
  table_id                    = try(each.value.table_id, each.key)
  friendly_name               = try(each.value.friendly_name, null)
  schema_path                 = each.value.schema_path
  description                 = try(each.value.description, null)
  labels                      = merge(var.labels, try(each.value.labels, {}))
  resource_tags               = try(each.value.resource_tags, null)
  deletion_protection         = try(each.value.deletion_protection, true)
  expiration_time             = try(each.value.expiration_time, null)
  max_staleness               = try(each.value.max_staleness, null)
  partition_type              = try(each.value.partition_type, null)
  partition_field             = try(each.value.partition_field, null)
  partition_expiration_ms     = try(each.value.partition_expiration_ms, null)
  require_partition_filter    = try(each.value.require_partition_filter, false)
  range_partitioning          = try(each.value.range_partitioning, null)
  clustering_fields           = try(each.value.clustering_fields, null)
  encryption_configuration    = try(each.value.encryption_configuration, null)
  table_constraints           = try(each.value.table_constraints, null)
  external_data_configuration = try(each.value.external_data_configuration, null)
  biglake_configuration       = try(each.value.biglake_configuration, null)
}

module "views" {
  source   = "./views"
  for_each = var.bigquery_views

  project_id           = var.project_id
  dataset_id           = each.value.dataset_id
  view_id              = try(each.value.view_id, each.key)
  friendly_name        = try(each.value.friendly_name, null)
  query                = each.value.query
  description          = try(each.value.description, null)
  labels               = merge(var.labels, try(each.value.labels, {}))
  resource_tags        = try(each.value.resource_tags, null)
  use_legacy_sql       = try(each.value.use_legacy_sql, false)
  is_materialized_view = try(each.value.is_materialized_view, false)
  enable_refresh       = try(each.value.enable_refresh, true)
  refresh_interval_ms  = try(each.value.refresh_interval_ms, null)
  max_staleness        = try(each.value.max_staleness, null)
  expiration_time      = try(each.value.expiration_time, null)
  deletion_protection  = try(each.value.deletion_protection, false)
}

module "routines" {
  source   = "./routines"
  for_each = var.bigquery_routines

  project_id              = var.project_id
  dataset_id              = each.value.dataset_id
  routine_id              = try(each.value.routine_id, each.key)
  definition_body         = each.value.definition_body
  routine_type            = try(each.value.routine_type, "PROCEDURE")
  language                = try(each.value.language, "SQL")
  description             = try(each.value.description, null)
  determinism_level       = try(each.value.determinism_level, null)
  return_type             = try(each.value.return_type, null)
  arguments               = try(each.value.arguments, null)
  imported_libraries      = try(each.value.imported_libraries, null)
  return_table_type       = try(each.value.return_table_type, null)
  data_governance_type    = try(each.value.data_governance_type, null)
  remote_function_options = try(each.value.remote_function_options, null)
  spark_options           = try(each.value.spark_options, null)
}
