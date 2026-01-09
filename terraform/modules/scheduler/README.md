# Module: Cloud Scheduler

Manages Google Cloud Scheduler jobs for automated task execution. Supports HTTP, Pub/Sub, and App Engine targets with configurable retry policies and authentication.

## Features

- **Job Targets**:
  - **HTTP**: Trigger any HTTP endpoint (Cloud Functions, Cloud Run, external APIs) with OIDC or OAuth authentication.
  - **Pub/Sub**: Publish messages to Pub/Sub topics.
  - **App Engine**: Trigger App Engine services.
- **Scheduling**: flexible cron-style syntax and time zone configuration.
- **Reliability**: Configurable retry policies (max doublings, backoff, retry counts).

## Usage

```hcl
module "scheduler" {
  source = "../../modules/scheduler"

  project_id = var.project_id
  region     = "us-central1"

  scheduler_jobs = {
    # 1. HTTP Target (e.g. Invoking a Cloud Function)
    "nightly-batch-job" = {
      description = "Triggers nightly batch processing"
      schedule    = "0 0 * * *" # Every midnight
      time_zone   = "America/New_York"
      
      http_target = {
        uri                  = "https://us-central1-my-project.cloudfunctions.net/batch-processor"
        http_method          = "POST"
        body                 = "{\"action\": \"start\"}"
        oidc_service_account = "scheduler-sa@my-project.iam.gserviceaccount.com"
      }
    }

    # 2. Pub/Sub Target
    "hourly-ping" = {
      description = "Sends a ping to Pub/Sub every hour"
      schedule    = "0 * * * *"
      
      pubsub_target = {
        topic_name = "projects/my-project/topics/ping-topic"
        data       = "ping"
      }

      retry_config = {
        retry_count = 3
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.jobs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_project_service.appengine](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.cloudscheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [null_resource.app_engine_create](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_app_engine_location"></a> [app\_engine\_location](#input\_app\_engine\_location) | Location for App Engine application | `string` | `"us-central"` | no |
| <a name="input_app_engine_service_account"></a> [app\_engine\_service\_account](#input\_app\_engine\_service\_account) | Service account to use for App Engine (required if default SA is deleted) | `string` | `""` | no |
| <a name="input_create_app_engine"></a> [create\_app\_engine](#input\_create\_app\_engine) | Whether to create an App Engine application (required for Cloud Scheduler in some regions) | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Default GCP region for scheduler jobs | `string` | `"us-central1"` | no |
| <a name="input_scheduler_jobs"></a> [scheduler\_jobs](#input\_scheduler\_jobs) | Map of Cloud Scheduler jobs to create | <pre>map(object({<br/>    description = optional(string, "Managed by Terraform")<br/>    schedule    = string # Cron expression (e.g., "0 9 * * 1" for every Monday at 9am)<br/>    time_zone   = optional(string, "UTC")<br/>    region      = optional(string)<br/>    paused      = optional(bool, false)<br/><br/>    attempt_deadline = optional(string, "320s")<br/><br/>    retry_config = optional(object({<br/>      retry_count          = optional(number, 0)<br/>      max_retry_duration   = optional(string)<br/>      min_backoff_duration = optional(string, "5s")<br/>      max_backoff_duration = optional(string, "3600s")<br/>      max_doublings        = optional(number, 5)<br/>    }))<br/><br/>    # HTTP Target (mutually exclusive with pubsub_target and app_engine_target)<br/>    http_target = optional(object({<br/>      uri                   = string<br/>      http_method           = optional(string, "POST")<br/>      body                  = optional(string)<br/>      headers               = optional(map(string))<br/>      oauth_service_account = optional(string)<br/>      oauth_scope           = optional(string)<br/>      oidc_service_account  = optional(string)<br/>      oidc_audience         = optional(string)<br/>    }))<br/><br/>    # Pub/Sub Target (mutually exclusive with http_target and app_engine_target)<br/>    pubsub_target = optional(object({<br/>      topic_name = string<br/>      data       = optional(string)<br/>      attributes = optional(map(string))<br/>    }))<br/><br/>    # App Engine Target (mutually exclusive with http_target and pubsub_target)<br/>    app_engine_target = optional(object({<br/>      http_method  = optional(string, "POST")<br/>      relative_uri = string<br/>      body         = optional(string)<br/>      headers      = optional(map(string))<br/>      service      = optional(string)<br/>      version      = optional(string)<br/>      instance     = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_engine_location"></a> [app\_engine\_location](#output\_app\_engine\_location) | App Engine application location (if created) |
| <a name="output_job_ids"></a> [job\_ids](#output\_job\_ids) | Map of job names to their IDs |
| <a name="output_job_names"></a> [job\_names](#output\_job\_names) | Map of job names to their full resource names |
<!-- END_TF_DOCS -->
