# terraform/modules/cloud_run/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for Cloud Run."
  type        = string
}

variable "services" {
  description = "A map of Cloud Run services to create."
  type = map(object({
    image              = string
    description        = optional(string)
    service_account    = optional(string)
    ingress            = optional(string, "INGRESS_TRAFFIC_ALL")
    cpu                = optional(string, "1000m")
    memory             = optional(string, "512Mi")
    cpu_idle           = optional(bool, true)
    vpc_connector      = optional(string)
    min_instance_count = optional(number, 0)
    max_instance_count = optional(number, 10)
    invoker_members    = optional(list(string))
    env_vars           = optional(map(string), {})
    traffic = optional(list(object({
      percent  = number
      type     = optional(string, "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST")
      revision = optional(string)
      tag      = optional(string)
    })), [])

    # Advanced Cloud Run v2 attributes
    max_instance_request_concurrency = optional(number)
    timeout                          = optional(string)
    execution_environment            = optional(string) # EXECUTION_ENVIRONMENT_GEN1, EXECUTION_ENVIRONMENT_GEN2
    binary_authorization = optional(object({
      use_default = optional(bool)
      policy      = optional(string)
    }))
    custom_audiences = optional(list(string))

    # Probe configuration
    liveness_probe = optional(object({
      initial_delay_seconds = optional(number)
      timeout_seconds       = optional(number)
      period_seconds        = optional(number)
      failure_threshold     = optional(number)
      http_get = optional(object({
        path = optional(string)
        port = optional(number)
      }))
    }))
    startup_probe = optional(object({
      initial_delay_seconds = optional(number)
      timeout_seconds       = optional(number)
      period_seconds        = optional(number)
      failure_threshold     = optional(number)
      http_get = optional(object({
        path = optional(string)
        port = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "jobs" {
  description = "A map of Cloud Run jobs to create."
  type = map(object({
    image           = string
    service_account = optional(string)
    cpu             = optional(string, "1000m")
    memory          = optional(string, "512Mi")
    vpc_connector   = optional(string)
    env_vars        = optional(map(string), {})
    max_retries     = optional(number)
    timeout         = optional(string)
  }))
  default = {}
}

variable "labels" {
  description = "A map of labels to apply to all resources."
  type        = map(string)
  default     = {}
}
