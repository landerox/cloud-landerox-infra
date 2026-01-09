# terraform/modules/storage/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for the buckets."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., prd, dev)."
  type        = string
}

variable "buckets" {
  description = "A map of buckets to create."
  type = map(object({
    location                 = optional(string)
    storage_class            = optional(string, "STANDARD")
    uniform_access           = optional(bool, true)
    versioning_enabled       = optional(bool, false)
    public_access_prevention = optional(string, "enforced")
    enable_logging           = optional(bool, false)
    enable_lifecycle         = optional(bool, false)
    labels                   = optional(map(string))

    encryption = optional(object({
      default_kms_key_name = string
    }))

    retention_policy = optional(object({
      retention_period = number
      is_locked        = optional(bool, false)
    }))

    cors = optional(list(object({
      origin          = list(string)
      method          = list(string)
      response_header = list(string)
      max_age_seconds = number
    })))

    lifecycle_rules = optional(list(object({
      action_type                = string
      action_storage_class       = optional(string)
      age_days                   = optional(number)
      matches_storage_class      = optional(list(string))
      num_newer_versions         = optional(number)
      days_since_noncurrent_time = optional(number)
      is_live                    = optional(bool)
    })))

    # New advanced attributes for Google Provider 7.x
    soft_delete_policy = optional(object({
      retention_duration_seconds = optional(number)
    }))

    autoclass = optional(object({
      enabled                = bool
      terminal_storage_class = optional(string)
    }))

    hierarchical_namespace = optional(object({
      enabled = bool
    }))

    custom_placement_config = optional(object({
      data_locations = list(string)
    }))

    website = optional(object({
      main_page_suffix = optional(string)
      not_found_page   = optional(string)
    }))
  }))
  default = {}
}

variable "labels" {
  description = "A map of labels to apply to all resources."
  type        = map(string)
  default     = {}
}
