# Module: BigQuery

Manages BigQuery structure including Datasets, Tables, Views, and Routines (UDFs/Procedures).

## Features

- **Datasets**: Configurable locations, retention, encryption (KMS), and granular access controls.
- **Tables**:
  - Schema definition (JSON file or inline).
  - Partitioning (Time-based, Range-based).
  - Clustering for query optimization.
  - **BigLake**: Support for external tables with fine-grained security.
  - **Constraints**: Support for Primary and Foreign keys.
  - Deletion protection.
- **Views**: Standard SQL, Legacy SQL, and **Materialized Views** with auto-refresh.
- **Routines**: Procedures and Functions (SQL, JavaScript, Python, Spark). Supports Remote Functions.

## Usage

```hcl
module "bigquery" {
  source = "../../modules/bigquery"

  project_id = var.project_id

  # 1. Datasets
  bigquery_datasets = {
    "analytics_prod" = {
      friendly_name              = "Production Analytics"
      description                = "Main dataset for business analytics"
      location                   = "US"
      delete_contents_on_destroy = false
    }
  }

  # 2. Tables
  bigquery_tables = {
    "events_raw" = {
      dataset_id          = "analytics_prod"
      table_id            = "events"
      schema_path         = "schemas/events.json" # Local path to schema file
      deletion_protection = true

      # Optimization
      partition_type  = "DAY"
      partition_field = "event_timestamp"
      clustering_fields = ["user_id", "event_type"]
    }
  }

  # 3. Views
  bigquery_views = {
    "vi_daily_summary" = {
      dataset_id = "analytics_prod"
      query      = "SELECT DATE(event_timestamp) as date, COUNT(*) as total FROM `my-project.analytics_prod.events` GROUP BY 1"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_datasets"></a> [datasets](#module\_datasets) | ./datasets | n/a |
| <a name="module_routines"></a> [routines](#module\_routines) | ./routines | n/a |
| <a name="module_tables"></a> [tables](#module\_tables) | ./tables | n/a |
| <a name="module_views"></a> [views](#module\_views) | ./views | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | n/a | yes |
| <a name="input_bigquery_datasets"></a> [bigquery\_datasets](#input\_bigquery\_datasets) | A map of BigQuery datasets to create. | `any` | `{}` | no |
| <a name="input_bigquery_routines"></a> [bigquery\_routines](#input\_bigquery\_routines) | A map of BigQuery routines to create. | `any` | `{}` | no |
| <a name="input_bigquery_tables"></a> [bigquery\_tables](#input\_bigquery\_tables) | A map of BigQuery tables to create. | `any` | `{}` | no |
| <a name="input_bigquery_views"></a> [bigquery\_views](#input\_bigquery\_views) | A map of BigQuery views to create. | `any` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataset_ids"></a> [dataset\_ids](#output\_dataset\_ids) | IDs of the created BigQuery datasets. |
| <a name="output_routine_ids"></a> [routine\_ids](#output\_routine\_ids) | IDs of the created BigQuery routines. |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | IDs of the created BigQuery tables. |
| <a name="output_view_ids"></a> [view\_ids](#output\_view\_ids) | IDs of the created BigQuery views. |
<!-- END_TF_DOCS -->
