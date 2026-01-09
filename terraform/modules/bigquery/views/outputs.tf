# terraform/modules/bigquery/views/outputs.tf

output "view" {
  description = "The created BigQuery view."
  value       = google_bigquery_table.this
}

output "view_id" {
  description = "The ID of the view."
  value       = google_bigquery_table.this.table_id
}
