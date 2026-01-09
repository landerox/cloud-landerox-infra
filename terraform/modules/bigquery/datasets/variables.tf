# terraform/modules/bigquery/datasets/variables.tf

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "dataset_id" {
  description = "A unique ID for this dataset, without the project name."
  type        = string
}

variable "location" {
  description = "The geographic location where the dataset should reside."
  type        = string
  default     = "US"
}

variable "friendly_name" {
  description = "A descriptive name for the dataset."
  type        = string
  default     = null
}

variable "description" {
  description = "A user-friendly description of the dataset."
  type        = string
  default     = null
}

variable "labels" {
  description = "The labels associated with this dataset."
  type        = map(string)
  default     = null
}

variable "resource_tags" {
  description = "The resource tags associated with this dataset."
  type        = map(string)
  default     = null
}

variable "delete_contents_on_destroy" {
  description = "If set to `true`, delete all the tables in the dataset when the dataset is destroyed."
  type        = bool
  default     = false
}

variable "default_table_expiration_ms" {
  description = "The default lifetime of all tables in the dataset, in milliseconds."
  type        = number
  default     = null
}

variable "default_partition_expiration_ms" {
  description = "The default partition expiration for all partitioned tables in the dataset, in milliseconds."
  type        = number
  default     = null
}

variable "max_time_travel_hours" {
  description = "Defines the time travel window in hours. The valid range is 48 to 168 hours."
  type        = string
  default     = null
}

variable "is_case_insensitive" {
  description = "True if the dataset and its table names are case-insensitive."
  type        = bool
  default     = null
}

variable "storage_billing_model" {
  description = "Specifies the storage billing model for the dataset (LOGICAL or PHYSICAL)."
  type        = string
  default     = null
}

variable "default_encryption_configuration" {
  description = "The default encryption configuration for all tables in the dataset."
  type = object({
    kms_key_name = string
  })
  default = null
}

variable "access" {
  description = "An array of objects that define dataset access for one or more entities."
  type = list(object({
    role           = optional(string)
    user_by_email  = optional(string)
    group_by_email = optional(string)
    domain         = optional(string)
    special_group  = optional(string)
    iam_member     = optional(string)
    dataset = optional(object({
      dataset_id   = string
      project_id   = string
      target_types = list(string)
    }))
    routine = optional(object({
      dataset_id = string
      project_id = string
      routine_id = string
    }))
    view = optional(object({
      dataset_id = string
      project_id = string
      view_id    = string
    }))
  }))
  default = null
}
