# terraform/modules/bigquery/routines/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_bigquery_routine" "this" {
  project              = var.project_id
  dataset_id           = var.dataset_id
  routine_id           = var.routine_id
  routine_type         = var.routine_type
  language             = var.language
  description          = var.description
  determinism_level    = var.determinism_level
  return_type          = var.return_type
  return_table_type    = var.return_table_type
  imported_libraries   = var.imported_libraries
  definition_body      = var.definition_body
  data_governance_type = var.data_governance_type

  dynamic "arguments" {
    for_each = var.arguments != null ? var.arguments : []
    content {
      name          = arguments.value.name
      data_type     = can(jsondecode(arguments.value.data_type)) ? arguments.value.data_type : jsonencode({ typeKind = arguments.value.data_type })
      argument_kind = arguments.value.argument_kind
      mode          = arguments.value.mode
    }
  }

  dynamic "remote_function_options" {
    for_each = var.remote_function_options != null ? [var.remote_function_options] : []
    content {
      endpoint             = remote_function_options.value.endpoint
      connection           = remote_function_options.value.connection
      user_defined_context = remote_function_options.value.user_defined_context
      max_batching_rows    = remote_function_options.value.max_batching_rows
    }
  }

  dynamic "spark_options" {
    for_each = var.spark_options != null ? [var.spark_options] : []
    content {
      connection      = spark_options.value.connection
      runtime_version = spark_options.value.runtime_version
      container_image = spark_options.value.container_image
      properties      = spark_options.value.properties
      main_file_uri   = spark_options.value.main_file_uri
      py_file_uris    = spark_options.value.py_file_uris
      jar_uris        = spark_options.value.jar_uris
      file_uris       = spark_options.value.file_uris
      archive_uris    = spark_options.value.archive_uris
      main_class      = spark_options.value.main_class
    }
  }
}
