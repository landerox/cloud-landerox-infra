variable "project_id" {
  description = "GCP project ID"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters, lowercase letters, digits, hyphens."
  }
}

variable "environment" {
  description = "Environment name (none, dev, tst, prd). Use 'none' for single-environment projects."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "dev", "tst", "prd"], var.environment)
    error_message = "Environment must be: none, dev, tst, or prd."
  }
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

# tflint-ignore: terraform_unused_declarations
variable "state_bucket" {
  description = "Name of the GCS bucket for Terraform state (used by Justfile)"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "state_bucket_class" {
  description = "Storage class for state bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  type        = string
  default     = "STANDARD"
}

variable "repository_id" {
  description = "GitHub repository ID (owner/repo)"
  type        = string
  default     = ""
}

variable "wif_repositories" {
  description = "List of GitHub repositories (owner/repo) allowed to assume identities via WIF"
  type = list(object({
    repo            = string
    service_account = string
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    created_by = "terraform"
  }
}

locals {
  # Combined labels for all resources
  all_labels = merge(
    var.labels,
    {
      cost_center         = var.cost_center
      owner               = var.owner
      data_classification = var.data_classification
      compliance_scope    = var.compliance_scope
    }
  )
}

# Module toggles
variable "enable_iam_module" {
  description = "Enable IAM module"
  type        = bool
  default     = true
}

variable "enable_storage_module" {
  description = "Enable Storage module"
  type        = bool
  default     = true
}

variable "enable_bigquery_module" {
  description = "Enable BigQuery module"
  type        = bool
  default     = false
}

variable "enable_secrets_module" {
  description = "Enable Secret Manager module"
  type        = bool
  default     = false
}

variable "enable_scheduler_module" {
  description = "Enable Cloud Scheduler module"
  type        = bool
  default     = false
}

variable "enable_artifact_registry_module" {
  description = "Enable Artifact Registry module"
  type        = bool
  default     = false
}

variable "enable_cloud_run_module" {
  description = "Enable Cloud Run module"
  type        = bool
  default     = false
}

# === Governance Variables ===

variable "cost_center" {
  description = "Cost center for billing and reporting"
  type        = string
  default     = "shared-services"
}

variable "owner" {
  description = "Owner of the resources (team or individual)"
  type        = string
  default     = "platform-team"
}

variable "data_classification" {
  description = "Data classification level (public, internal, confidential, restricted)"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.data_classification)
    error_message = "Data classification must be one of: public, internal, confidential, restricted."
  }
}

variable "compliance_scope" {
  description = "Compliance scope (none, soc2, pci-dss, hipaa)"
  type        = string
  default     = "none"
}

# === Workload Identity Federation ===

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-pool"
}

variable "workload_identity_pool_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "github-provider"
}
