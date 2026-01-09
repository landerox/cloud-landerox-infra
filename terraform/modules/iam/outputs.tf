output "service_accounts" {
  description = "Created service accounts"
  value = {
    for name, sa in google_service_account.accounts :
    name => {
      email     = sa.email
      unique_id = sa.unique_id
    }
  }
}

output "service_account_emails" {
  description = "Service account emails (for easy reference)"
  value = {
    for name, sa in google_service_account.accounts :
    name => sa.email
  }
}
