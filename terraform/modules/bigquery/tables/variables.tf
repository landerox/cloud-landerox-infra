# terraform/modules/bigquery/tables/variables.tf

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "dataset_id" {
  description = "The ID of the dataset containing this table."
  type        = string
}

variable "table_id" {
  description = "The ID of the table."
  type        = string
}

variable "friendly_name" {
  description = "A descriptive name for the table."
  type        = string
  default     = null
}

variable "schema_path" {
  description = "The path to the JSON file containing the table schema."
  type        = string
  default     = null
}

variable "description" {
  description = "A user-friendly description of the table."
  type        = string
  default     = null
}

variable "labels" {
  description = "The labels associated with this table."
  type        = map(string)
  default     = null
}

variable "resource_tags" {
  description = "The resource tags associated with this table."
  type        = map(string)
  default     = null
}

variable "deletion_protection" {
  description = "Set to `true` to prevent accidental deletion."
  type        = bool
  default     = true
}

variable "expiration_time" {
  description = "The time when this table expires, in milliseconds since the epoch."
  type        = number
  default     = null
}

variable "max_staleness" {
  description = "The maximum staleness of data that could be returned when the table (or a stale view) is queried."
  type        = string
  default     = null
}

# Time Partitioning
variable "partition_type" {
  description = "The type of time-based partitioning to apply (DAY, HOUR, MONTH, YEAR)."
  type        = string
  default     = null
  validation {
    condition     = var.partition_type == null || can(regex("^(DAY|HOUR|MONTH|YEAR)$", var.partition_type))
    error_message = "Allowed values for partition_type are DAY, HOUR, MONTH, YEAR."
  }
}

variable "partition_field" {
  description = "The field to use for partitioning. If not set, the table is partitioned by pseudo column '_PARTITIONTIME'."
  type        = string
  default     = null
}

variable "partition_expiration_ms" {
  description = "Number of milliseconds for which to keep the storage for a partition."
  type        = number
  default     = null
}

variable "require_partition_filter" {
  description = "If set to `true`, queries over this table require a partition filter."
  type        = bool
  default     = false
}

# Range Partitioning
variable "range_partitioning" {
  description = "Configures range-based partitioning for this table."
  type = object({
    field = string
    range = object({
      start    = number
      end      = number
      interval = number
    })
  })
  default = null
}

# Clustering
variable "clustering_fields" {
  description = "A list of up to four fields to cluster this table by."
  type        = list(string)
  default     = null
}

# Security
variable "encryption_configuration" {
  description = "The encryption configuration for the table."
  type = object({
    kms_key_name = string
  })
  default = null
}

# Table Constraints
variable "table_constraints" {
  description = "The table constraints for the table."
  type = object({
    primary_key = optional(object({
      columns = list(string)
    }))
    foreign_keys = optional(list(object({
      name = optional(string)
      referenced_table = object({
        project_id = string
        dataset_id = string
        table_id   = string
      })
      column_references = list(object({
        referenced_column  = string
        referencing_column = string
      }))
    })))
  })
  default = null
}

# External Tables
variable "external_data_configuration" {
  description = "Describes the data source for external tables."
  type = object({
    autodetect    = bool
    source_format = string
    source_uris   = list(string)
    compression   = optional(string)
    connection_id = optional(string)
    csv_options = optional(object({
      quote                 = optional(string)
      allow_jagged_rows     = optional(bool)
      allow_quoted_newlines = optional(bool)
      encoding              = optional(string)
      field_delimiter       = optional(string)
      skip_leading_rows     = optional(number)
    }))
    google_sheets_options = optional(object({
      range             = optional(string)
      skip_leading_rows = optional(number)
    }))
    hive_partitioning_options = optional(object({
      mode              = optional(string)
      source_uri_prefix = optional(string)
    }))
  })
  default = null
}

# BigLake
variable "biglake_configuration" {
  description = "Specifies the configuration of a BigLake managed table."
  type = object({
    connection_id = string
    storage_uri   = string
    source_format = string
    table_format  = string
  })
  default = null
}
