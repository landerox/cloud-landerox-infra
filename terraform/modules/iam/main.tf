# terraform/modules/iam/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}
locals {
  # Backward compatibility: If repository_id is set, treat it as the "main" repo linked to sa-terraform
  legacy_repo_config = var.repository_id != "" ? [{
    repo            = var.repository_id
    service_account = var.sa_terraform_name
  }] : []

  # Combine legacy config with new list
  all_wif_configs = concat(local.legacy_repo_config, var.wif_repositories)

  # List of just the repo names for the Provider condition
  all_allowed_repos = distinct([for config in local.all_wif_configs : config.repo])

  # Calculate if we should create WIF resources
  enable_wif = length(local.all_allowed_repos) > 0

  impersonation_bindings = flatten([
    for sa_key, sa_config in var.service_accounts : [
      for user in sa_config.impersonation_users : {
        sa_key = sa_key
        user   = user
      }
    ]
  ])

  project_iam_bindings_list = flatten([
    for key, config in var.project_iam_bindings : [
      for member in config.members : {
        key       = key
        role      = config.role
        member    = member
        condition = config.condition
      }
    ]
  ])
}

resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "main" {
  count                     = local.enable_wif ? 1 : 0
  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
  disabled                  = var.wif_pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "main" {
  count                              = local.enable_wif ? 1 : 0
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.main[0].workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
  display_name                       = "GitHub Actions Provider"
  disabled                           = var.wif_provider_disabled
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  # Security: Only allow authentication if the repository is in our allowed list
  attribute_condition = "attribute.repository in ['${join("','", local.all_allowed_repos)}']"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "accounts" {
  for_each = var.service_accounts

  project                      = var.project_id
  account_id                   = each.key
  display_name                 = each.value.display_name
  description                  = each.value.description
  disabled                     = each.value.disabled
  create_ignore_already_exists = each.value.create_ignore_already_exists

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "roles" {
  for_each = merge([
    for sa_key, sa_config in var.service_accounts : {
      for role in sa_config.roles :
      "${sa_key}-${role}" => {
        sa_email = google_service_account.accounts[sa_key].email
        role     = role
      }
    }
  ]...)

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.sa_email}"
}

# Grant Workload Identity User role to specific repos for specific Service Accounts
resource "google_service_account_iam_member" "wif_user" {
  for_each = {
    for config in local.all_wif_configs : "${config.repo}-${config.service_account}" => config
    if local.enable_wif
  }

  service_account_id = google_service_account.accounts[each.value.service_account].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main[0].name}/attribute.repository/${each.value.repo}"
}

resource "google_service_account_iam_member" "impersonation" {
  for_each = { for binding in local.impersonation_bindings : "${binding.sa_key}-${binding.user}" => binding }

  service_account_id = google_service_account.accounts[each.value.sa_key].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = each.value.user
}

# ==============================================================================
# Custom Roles
# ==============================================================================
resource "google_project_iam_custom_role" "custom_roles" {
  for_each = var.custom_roles

  project     = var.project_id
  role_id     = each.key
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
  stage       = each.value.stage
}

# ==============================================================================
# Generic Project IAM Bindings
# ==============================================================================
resource "google_project_iam_member" "project_iam" {
  for_each = {
    for binding in local.project_iam_bindings_list :
    "${binding.key}-${binding.member}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      title       = condition.value.title
      description = condition.value.description
      expression  = condition.value.expression
    }
  }
}
