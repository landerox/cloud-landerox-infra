# terraform/modules/bigquery/scheduled_queries/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description = "The GCP location for the transfer config."
  type        = string
}

variable "display_name" {
  description = "The user specified display name for the transfer config."
  type        = string
}

variable "destination_dataset_id" {
  description = "The BigQuery dataset ID to which results are written."
  type        = string
}

variable "query" {
  description = "The BigQuery query to be executed."
  type        = string
}

variable "destination_table_name_template" {
  description = "The table name template. Use {run_time} or {run_date} macros."
  type        = string
  default     = null
}

variable "write_disposition" {
  description = "Specifies the action if the destination table already exists."
  type        = string
  default     = "WRITE_TRUNCATE"
}

variable "schedule" {
  description = "The schedule for the query execution (e.g., 'every 24 hours')."
  type        = string
  default     = null
}

variable "disabled" {
  description = "If set to true, the transfer will be disabled."
  type        = bool
  default     = false
}

variable "service_account_name" {
  description = "The service account to use to run the transfer."
  type        = string
  default     = null
}

variable "schedule_options" {
  description = "Options for the schedule."
  type = object({
    start_time = optional(string)
    end_time   = optional(string)
  })
  default = null
}

variable "email_preferences" {
  description = "Email preferences."
  type = object({
    enable_failure_email = bool
  })
  default = null
}

variable "notification_pubsub_topic" {
  description = "Pub/Sub topic for notifications."
  type        = string
  default     = null
}

variable "data_refresh_window_days" {
  description = "The number of days to look back to automatically refresh the data."
  type        = number
  default     = null
}

variable "encryption_configuration" {
  description = "Encryption configuration for the transfer."
  type = object({
    kms_key_name = string
  })
  default = null
}
