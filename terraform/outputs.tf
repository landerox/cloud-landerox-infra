output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP Region"
  value       = var.region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "iam_outputs" {
  description = "IAM module outputs"
  value       = try(module.iam[0], null)
}

output "storage_outputs" {
  description = "Outputs from the storage module."
  value       = try(module.storage[0], null)
}

output "bigquery_outputs" {
  description = "BigQuery module outputs"
  value       = try(module.bigquery_datasets[0], null)
}

output "secrets_outputs" {
  description = "Secrets module outputs"
  value       = try(module.secrets[0], null)
}

output "scheduler_outputs" {
  description = "Cloud Scheduler module outputs"
  value       = try(module.scheduler[0], null)
}

output "artifact_registry_outputs" {
  description = "Artifact Registry module outputs"
  value       = try(module.artifact_registry[0], null)
}

output "cloud_run_outputs" {
  description = "Cloud Run module outputs"
  value       = try(module.cloud_run[0], null)
}
