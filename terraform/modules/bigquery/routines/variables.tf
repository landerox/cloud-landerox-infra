# terraform/modules/bigquery/routines/variables.tf

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "dataset_id" {
  description = "The ID of the dataset containing this routine."
  type        = string
}

variable "routine_id" {
  description = "The ID of the routine."
  type        = string
}

variable "definition_body" {
  description = "The body of the routine."
  type        = string
}

variable "routine_type" {
  description = "The type of routine (PROCEDURE, SCALAR_FUNCTION, TABLE_VALUED_FUNCTION)."
  type        = string
  default     = "PROCEDURE"
}

variable "language" {
  description = "The language of the routine (SQL, JAVASCRIPT, PYTHON, SCALA, JAVA)."
  type        = string
  default     = "SQL"
}

variable "description" {
  description = "A user-friendly description of the routine."
  type        = string
  default     = null
}

variable "determinism_level" {
  description = "The determinism level of the JavaScript UDF (DETERMINISTIC or NOT_DETERMINISTIC)."
  type        = string
  default     = null
}

variable "return_type" {
  description = "The return type of a SQL UDF in JSON format."
  type        = string
  default     = null
}

variable "return_table_type" {
  description = "The return type of a TABLE_VALUED_FUNCTION routine, in JSON format."
  type        = string
  default     = null
}

variable "arguments" {
  description = "A list of argument objects for the routine."
  type = list(object({
    name          = optional(string)
    data_type     = optional(string)
    argument_kind = optional(string)
    mode          = optional(string)
  }))
  default = null
}

variable "imported_libraries" {
  description = "A list of imported GCS URIs for JavaScript libraries."
  type        = list(string)
  default     = null
}

variable "data_governance_type" {
  description = "If multisets of rows are allowed as input and output. (DATA_MASKING)."
  type        = string
  default     = null
}

variable "remote_function_options" {
  description = "Remote function specific options."
  type = object({
    endpoint             = optional(string)
    connection           = optional(string)
    user_defined_context = optional(map(string))
    max_batching_rows    = optional(number)
  })
  default = null
}

variable "spark_options" {
  description = "Spark specific options."
  type = object({
    connection      = optional(string)
    runtime_version = optional(string)
    container_image = optional(string)
    properties      = optional(map(string))
    main_file_uri   = optional(string)
    py_file_uris    = optional(list(string))
    jar_uris        = optional(list(string))
    file_uris       = optional(list(string))
    archive_uris    = optional(list(string))
    main_class      = optional(string)
  })
  default = null
}
