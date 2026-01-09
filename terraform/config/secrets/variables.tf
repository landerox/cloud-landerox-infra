variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

variable "labels" {
  description = "Labels to apply to all secrets"
  type        = map(string)
  default     = {}
}
