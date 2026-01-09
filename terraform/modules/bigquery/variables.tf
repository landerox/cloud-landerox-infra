variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "bigquery_datasets" {
  description = "A map of BigQuery datasets to create."
  type        = any
  default     = {}
}

variable "bigquery_tables" {
  description = "A map of BigQuery tables to create."
  type        = any
  default     = {}
}

variable "bigquery_views" {
  description = "A map of BigQuery views to create."
  type        = any
  default     = {}
}

variable "bigquery_routines" {
  description = "A map of BigQuery routines to create."
  type        = any
  default     = {}
}
