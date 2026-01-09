variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "repository_id" {
  description = "GitHub repository ID (owner/repo)"
  type        = string
  default     = ""
}

variable "wif_repos" {
  description = "List of GitHub repositories (owner/repo) allowed to assume identities via WIF"
  type = list(object({
    repo            = string
    service_account = string
  }))
  default = []
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
}

variable "workload_identity_pool_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
}
