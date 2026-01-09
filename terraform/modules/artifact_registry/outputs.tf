# terraform/modules/artifact_registry/outputs.tf

output "repositories" {
  description = "The created Artifact Registry repositories."
  value       = google_artifact_registry_repository.this
}
