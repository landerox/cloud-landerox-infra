# terraform/modules/iam/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "service_accounts" {
  description = "Service accounts to create with least-privilege roles"
  type = map(object({
    display_name                 = string
    description                  = optional(string)
    roles                        = optional(list(string), [])
    impersonation_users          = optional(list(string), [])
    disabled                     = optional(bool, false)
    create_ignore_already_exists = optional(bool, false)
  }))
  default = {}
}

variable "workload_identity_pool_id" {
  description = "The ID of the Workload Identity Pool."
  type        = string
  default     = "github-pool"
}

variable "workload_identity_pool_provider_id" {
  description = "The ID of the Workload Identity Pool Provider."
  type        = string
  default     = "github-provider"
}

variable "sa_terraform_name" {
  description = "The name of the Terraform service account."
  type        = string
  default     = "sa-terraform"
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

variable "wif_pool_disabled" {
  description = "Whether the Workload Identity Pool is disabled."
  type        = bool
  default     = false
}

variable "wif_provider_disabled" {
  description = "Whether the Workload Identity Pool Provider is disabled."
  type        = bool
  default     = false
}

variable "custom_roles" {
  description = "Map of custom roles to create"
  type = map(object({
    title       = string
    description = optional(string)
    permissions = list(string)
    stage       = optional(string, "GA") # ALPHA, BETA, GA, DEPRECATED, EAP
  }))
  default = {}
}

variable "project_iam_bindings" {
  description = "Map of project-level IAM bindings (role -> members)"
  type = map(object({
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}
