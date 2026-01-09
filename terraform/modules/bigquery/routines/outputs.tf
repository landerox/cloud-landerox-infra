# terraform/modules/bigquery/routines/outputs.tf

output "routine" {
  description = "The created BigQuery routine."
  value       = google_bigquery_routine.this
}

output "routine_id" {
  description = "The ID of the routine."
  value       = google_bigquery_routine.this.routine_id
}
