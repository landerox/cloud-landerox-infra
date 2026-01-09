variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description = "The GCP location for all resources."
  type        = string
}

variable "labels" {
  description = "A map of labels to apply to all resources."
  type        = map(string)
  default     = {}
}
