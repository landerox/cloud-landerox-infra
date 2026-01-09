output "emails" {
  description = "Service account emails"
  value       = module.iam_service_accounts.service_account_emails
}

output "service_accounts" {
  description = "Full service account details"
  value       = module.iam_service_accounts.service_accounts
}
