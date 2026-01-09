output "repository_ids" {
  description = "The IDs of the Artifact Registry repositories created."
  value       = try(module.artifact_registry.repository_ids, {})
}
