# terraform/modules/secrets/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for secrets replication."
  type        = string
}

variable "secrets" {
  description = "A map of secrets to create."
  type = map(object({
    replication_type   = optional(string, "auto")
    replica_locations  = optional(list(string))
    kms_key_name       = optional(string)
    labels             = optional(map(string))
    initial_value      = optional(string)
    accessors          = optional(list(string))
    rotation_period    = optional(string)
    next_rotation_time = optional(string)
    pubsub_topic       = optional(string)

    # Advanced Secret Manager attributes
    expire_time     = optional(string)
    ttl             = optional(string)
    version_aliases = optional(map(string))
    annotations     = optional(map(string))
  }))
  default = {}
}

variable "labels" {
  description = "A map of labels to apply to all resources."
  type        = map(string)
  default     = {}
}
