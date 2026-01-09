# terraform/modules/bigquery/scheduled_queries/outputs.tf

output "transfer_config" {
  description = "The created BigQuery Data Transfer configuration."
  value       = google_bigquery_data_transfer_config.this
}

output "id" {
  description = "The ID of the transfer configuration."
  value       = google_bigquery_data_transfer_config.this.id
}
