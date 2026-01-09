output "secret_ids" {
  description = "The IDs of the secrets created in Secret Manager."
  value       = try(module.secrets.secret_ids, {})
}
