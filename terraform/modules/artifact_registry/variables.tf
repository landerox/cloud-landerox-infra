# terraform/modules/artifact_registry/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description = "The GCP region or multi-region for the repository."
  type        = string
}

variable "repositories" {
  description = "A map of Artifact Registry repositories to create."
  type = map(object({
    format       = string
    description  = optional(string)
    labels       = optional(map(string))
    mode         = optional(string, "STANDARD_REPOSITORY") # STANDARD_REPOSITORY, REMOTE_REPOSITORY, VIRTUAL_REPOSITORY
    kms_key_name = optional(string)

    cleanup_policy_dry_run = optional(bool)

    docker_config = optional(object({
      immutable_tags = optional(bool, false)
    }))

    remote_repository_config = optional(object({
      description                 = optional(string)
      disable_upstream_validation = optional(bool)
      docker_repository = optional(object({
        public_repository = optional(string) # DOCKER_HUB
      }))
      maven_repository = optional(object({
        public_repository = optional(string) # MAVEN_CENTRAL
      }))
      npm_repository = optional(object({
        public_repository = optional(string) # NPMJS
      }))
      python_repository = optional(object({
        public_repository = optional(string) # PYPI
      }))
    }))

    virtual_repository_config = optional(object({
      upstream_policies = optional(list(object({
        id         = string
        repository = string
        priority   = number
      })))
    }))

    cleanup_policies = optional(map(object({
      action = optional(string, "DELETE") # DELETE or KEEP
      condition = optional(object({
        tag_state             = optional(string) # TAGGED, UNTAGGED, ANY
        tag_prefixes          = optional(list(string))
        version_name_prefixes = optional(list(string))
        package_name_prefixes = optional(list(string))
        older_than            = optional(string) # e.g. "2592000s" (30 days)
        newer_than            = optional(string)
      }))
      most_recent_versions = optional(object({
        package_name_prefixes = optional(list(string))
        keep_count            = optional(number)
      }))
    })))

    vulnerability_scanning_config = optional(object({
      enablement_config = optional(string) # INHERITED, DISABLED
    }))
  }))
  default = {}
}

variable "labels" {
  description = "A map of labels to apply to all resources."
  type        = map(string)
  default     = {}
}
