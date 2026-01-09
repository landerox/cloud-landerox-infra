# terraform/config/bigquery/datasets/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

# =============================================================================
# DATASETS CREATION
# =============================================================================
module "datasets" {
  source   = "../../../modules/bigquery/datasets"
  for_each = local.datasets

  project_id    = var.project_id
  dataset_id    = each.key
  location      = var.location
  friendly_name = lookup(each.value, "friendly_name", title(replace(each.key, "_", " ")))
  description   = lookup(each.value, "description", null)
  labels        = var.labels

  # Advanced Datasets Configuration
  resource_tags                    = try(each.value.resource_tags, null)
  default_table_expiration_ms      = try(each.value.default_table_expiration_ms, null)
  default_partition_expiration_ms  = try(each.value.default_partition_expiration_ms, null)
  max_time_travel_hours            = try(each.value.max_time_travel_hours, null)
  is_case_insensitive              = try(each.value.is_case_insensitive, null)
  storage_billing_model            = try(each.value.storage_billing_model, null)
  default_encryption_configuration = try(each.value.default_encryption_configuration, null)
  access                           = try(each.value.access, null)
  delete_contents_on_destroy       = try(each.value.delete_contents_on_destroy, false)
}

# =============================================================================
# RESOURCE LOADING LOGIC
# =============================================================================
locals {
  # ---------------------------------------------------------------------------
  # TABLES
  # ---------------------------------------------------------------------------
  # 1. Find all dataset directories that have a tables.yaml
  dataset_tables_files = fileset(path.module, "*/tables.yaml")

  # 2. Load and flatten tables
  tables = flatten([
    for file_path in local.dataset_tables_files : [
      for table_key, table_config in coalesce(try(yamldecode(file("${path.module}/${file_path}"))["tables"], {}), {}) : {
        dataset_id = split("/", file_path)[0]
        table_key  = table_key
        # If "table_id" is specified in YAML, use it; otherwise use the YAML key
        table_id = try(table_config.table_id, table_key)
        config   = table_config
      }
    ]
  ])

  # ---------------------------------------------------------------------------
  # VIEWS
  # ---------------------------------------------------------------------------
  dataset_views_files = fileset(path.module, "*/views.yaml")

  views = flatten([
    for file_path in local.dataset_views_files : [
      for view_key, view_config in coalesce(try(yamldecode(file("${path.module}/${file_path}"))["views"], {}), {}) : {
        dataset_id = split("/", file_path)[0]
        view_key   = view_key
        view_id    = try(view_config.view_id, view_key)
        config     = view_config
      }
    ]
  ])

  # ---------------------------------------------------------------------------
  # ROUTINES
  # ---------------------------------------------------------------------------
  dataset_routines_files = fileset(path.module, "*/routines.yaml")

  routines = flatten([
    for file_path in local.dataset_routines_files : [
      for routine_key, routine_config in coalesce(try(yamldecode(file("${path.module}/${file_path}"))["routines"], {}), {}) : {
        dataset_id  = split("/", file_path)[0]
        routine_key = routine_key
        routine_id  = try(routine_config.routine_id, routine_key)
        config      = routine_config
      }
    ]
  ])

  # ---------------------------------------------------------------------------
  # SCHEDULED QUERIES
  # ---------------------------------------------------------------------------
  dataset_sq_files = fileset(path.module, "*/scheduled_queries.yaml")

  scheduled_queries = flatten([
    for file_path in local.dataset_sq_files : [
      for sq_key, sq_config in coalesce(try(yamldecode(file("${path.module}/${file_path}"))["scheduled_queries"], {}), {}) : {
        dataset_id   = split("/", file_path)[0]
        sq_key       = sq_key
        display_name = sq_key # or try(sq_config.display_name, sq_key)
        config       = sq_config
      }
    ]
  ])
}

# =============================================================================
# TABLES
# =============================================================================
module "tables" {
  source   = "../../../modules/bigquery/tables"
  for_each = { for t in local.tables : "${t.dataset_id}.${t.table_key}" => t }

  project_id = var.project_id
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id

  # Schema path is relative to the dataset folder
  schema_path = "${path.module}/${each.value.dataset_id}/${each.value.config.schema_path}"

  friendly_name = try(each.value.config.friendly_name, null)
  description   = try(each.value.config.description, null)
  labels        = try(each.value.config.labels, null)
  resource_tags = try(each.value.config.resource_tags, null)

  deletion_protection         = try(each.value.config.deletion_protection, true)
  expiration_time             = try(each.value.config.expiration_time, null)
  max_staleness               = try(each.value.config.max_staleness, null)
  partition_type              = try(each.value.config.partition_type, null)
  partition_field             = try(each.value.config.partition_field, null)
  partition_expiration_ms     = try(each.value.config.partition_expiration_ms, null)
  require_partition_filter    = try(each.value.config.require_partition_filter, false)
  range_partitioning          = try(each.value.config.range_partitioning, null)
  clustering_fields           = try(each.value.config.clustering_fields, null)
  encryption_configuration    = try(each.value.config.encryption_configuration, null)
  table_constraints           = try(each.value.config.table_constraints, null)
  external_data_configuration = try(each.value.config.external_data_configuration, null)
  biglake_configuration       = try(each.value.config.biglake_configuration, null)

  depends_on = [module.datasets]
}

# =============================================================================
# VIEWS
# =============================================================================
module "views" {
  source   = "../../../modules/bigquery/views"
  for_each = { for v in local.views : "${v.dataset_id}.${v.view_key}" => v }

  project_id = var.project_id
  dataset_id = each.value.dataset_id
  view_id    = each.value.view_id

  # Query path is relative to the dataset folder
  # We read the file content and apply variable substitution
  query = replace(
    replace(
      file("${path.module}/${each.value.dataset_id}/${each.value.config.query_path}"),
      "{project_id}", var.project_id
    ),
    "{dataset_id}", each.value.dataset_id
  )

  friendly_name        = try(each.value.config.friendly_name, null)
  description          = try(each.value.config.description, null)
  labels               = try(each.value.config.labels, null)
  resource_tags        = try(each.value.config.resource_tags, null)
  use_legacy_sql       = try(each.value.config.use_legacy_sql, false)
  is_materialized_view = try(each.value.config.is_materialized_view, false)
  enable_refresh       = try(each.value.config.enable_refresh, true)
  refresh_interval_ms  = try(each.value.config.refresh_interval_ms, null)
  max_staleness        = try(each.value.config.max_staleness, null)
  expiration_time      = try(each.value.config.expiration_time, null)
  deletion_protection  = try(each.value.config.deletion_protection, false)

  depends_on = [module.datasets]
}

# =============================================================================
# ROUTINES
# =============================================================================
module "routines" {
  source   = "../../../modules/bigquery/routines"
  for_each = { for r in local.routines : "${r.dataset_id}.${r.routine_key}" => r }

  project_id = var.project_id
  dataset_id = each.value.dataset_id
  routine_id = each.value.routine_id

  definition_body = replace(
    replace(
      file("${path.module}/${each.value.dataset_id}/${each.value.config.body_path}"),
      "{project_id}", var.project_id
    ),
    "{dataset_id}", each.value.dataset_id
  )

  description             = try(each.value.config.description, null)
  language                = try(each.value.config.language, "SQL")
  routine_type            = try(each.value.config.routine_type, "PROCEDURE")
  determinism_level       = try(each.value.config.determinism_level, null)
  return_type             = try(each.value.config.return_type, null)
  arguments               = try(each.value.config.arguments, null)
  imported_libraries      = try(each.value.config.imported_libraries, null)
  return_table_type       = try(each.value.config.return_table_type, null)
  data_governance_type    = try(each.value.config.data_governance_type, null)
  remote_function_options = try(each.value.config.remote_function_options, null)
  spark_options           = try(each.value.config.spark_options, null)

  depends_on = [module.datasets]
}

# =============================================================================
# SCHEDULED QUERIES
# =============================================================================
module "scheduled_queries" {
  source   = "../../../modules/bigquery/scheduled_queries"
  for_each = { for sq in local.scheduled_queries : "${sq.dataset_id}.${sq.sq_key}" => sq }

  project_id   = var.project_id
  location     = var.location
  display_name = each.value.display_name

  query = replace(
    replace(
      file("${path.module}/${each.value.dataset_id}/${each.value.config.query_path}"),
      "{project_id}", var.project_id
    ),
    "{dataset_id}", each.value.dataset_id
  )

  # Optional params
  destination_dataset_id          = try(each.value.config.destination_dataset_id, each.value.dataset_id)
  schedule                        = try(each.value.config.schedule, null)
  disabled                        = try(each.value.config.disabled, false)
  destination_table_name_template = try(each.value.config.destination_table_name_template, null)
  write_disposition               = try(each.value.config.write_disposition, "WRITE_TRUNCATE")
  service_account_name            = try(each.value.config.service_account_name, null)
  notification_pubsub_topic       = try(each.value.config.notification_pubsub_topic, null)
  schedule_options                = try(each.value.config.schedule_options, null)
  email_preferences               = try(each.value.config.email_preferences, null)
  data_refresh_window_days        = try(each.value.config.data_refresh_window_days, null)
  encryption_configuration        = try(each.value.config.encryption_configuration, null)

  depends_on = [module.datasets]
}
