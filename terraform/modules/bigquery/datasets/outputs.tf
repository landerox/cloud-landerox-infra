# terraform/modules/bigquery/datasets/outputs.tf

output "dataset" {
  description = "The created BigQuery dataset."
  value       = google_bigquery_dataset.this
}

output "dataset_id" {
  description = "The ID of the dataset."
  value       = google_bigquery_dataset.this.dataset_id
}
