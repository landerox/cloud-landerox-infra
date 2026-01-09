output "secret_ids" {
  description = "Map of secret names to their IDs"
  value = {
    for name, secret in google_secret_manager_secret.secrets : name => secret.id
  }
}

output "secret_names" {
  description = "Map of secret names to their full resource names"
  value = {
    for name, secret in google_secret_manager_secret.secrets : name => secret.name
  }
}

output "secret_versions" {
  description = "Map of secret names to their latest version IDs"
  value = {
    for name, version in google_secret_manager_secret_version.versions : name => version.id
  }
}
