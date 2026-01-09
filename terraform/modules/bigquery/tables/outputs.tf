# terraform/modules/bigquery/tables/outputs.tf

output "table" {
  description = "The created BigQuery table."
  value       = google_bigquery_table.this
}

output "table_id" {
  description = "The ID of the table."
  value       = google_bigquery_table.this.table_id
}
