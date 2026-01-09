# terraform/modules/bigquery/views/variables.tf

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "dataset_id" {
  description = "The ID of the dataset containing this view."
  type        = string
}

variable "view_id" {
  description = "The ID of the view."
  type        = string
}

variable "friendly_name" {
  description = "A descriptive name for the view."
  type        = string
  default     = null
}

variable "description" {
  description = "A user-friendly description of the view."
  type        = string
  default     = null
}

variable "labels" {
  description = "The labels associated with this view."
  type        = map(string)
  default     = null
}

variable "resource_tags" {
  description = "The resource tags associated with this view."
  type        = map(string)
  default     = null
}

variable "query" {
  description = "The query for the view."
  type        = string
}

variable "use_legacy_sql" {
  description = "Set to `true` to use legacy SQL for this view."
  type        = bool
  default     = false
}

variable "is_materialized_view" {
  description = "Whether to create a materialized view."
  type        = bool
  default     = false
}

variable "enable_refresh" {
  description = "Enable automatic refresh for materialized view."
  type        = bool
  default     = true
}

variable "refresh_interval_ms" {
  description = "Refresh interval in milliseconds for materialized view."
  type        = number
  default     = null
}

variable "max_staleness" {
  description = "The maximum staleness of data that could be returned when the view is queried."
  type        = string
  default     = null
}

variable "expiration_time" {
  description = "The time when this view expires, in milliseconds since the epoch."
  type        = number
  default     = null
}

variable "deletion_protection" {
  description = "Set to `true` to prevent accidental deletion."
  type        = bool
  default     = false
}
