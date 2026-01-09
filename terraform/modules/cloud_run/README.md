# Module: Cloud Run (V2)

Manages Cloud Run Services and Jobs (V2 API). Supports auto-scaling, traffic splitting, VPC connectivity, and secure invocation.

## Features

- **Cloud Run Services**:
  - **Traffic Management**: Canary deployments, percentage-based splits, and tag-based revisions.
  - **Scaling**: Min/Max instances, CPU ideal settings, and max instance request concurrency.
  - **Reliability**: Health probes (Liveness and Startup) support.
  - **Networking**: Ingress controls (Internal/All), VPC Connectors, and Custom Audiences.
  - **Security**: IAM Invoker bindings, Binary Authorization, and specific execution environments.
- **Cloud Run Jobs**:
  - Batch processing with parallelism, task counts, and retry limits.
  - VPC access for private resource connection (DBs, etc.).

## Usage

```hcl
module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id = var.project_id
  region     = "us-central1"

  # 1. Services
  services = {
    "api-service" = {
      image = "gcr.io/my-project/api:v1.0.0"
      
      # Resources
      cpu    = "1000m"
      memory = "512Mi"
      min_instance_count = 1
      max_instance_count = 10

      # Traffic (Blue/Green)
      traffic = [
        { percent = 100, type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST" }
      ]

      # Security
      ingress         = "INGRESS_TRAFFIC_ALL"
      invoker_members = ["allUsers"] # Public Service
      
      env_vars = {
        "LOG_LEVEL" = "info"
      }
    }
  }

  # 2. Jobs
  jobs = {
    "data-migration" = {
      image       = "gcr.io/my-project/migrator:latest"
      task_count  = 5
      parallelism = 2
      
      vpc_connector = "projects/my-project/locations/us-central1/connectors/main-connector"
      
      env_vars = {
        "DB_HOST" = "10.0.0.5"
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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service_iam_binding.invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_binding) | resource |
| [google_cloud_run_v2_job.jobs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job) | resource |
| [google_cloud_run_v2_service.services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_project_service.run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for Cloud Run. | `string` | n/a | yes |
| <a name="input_jobs"></a> [jobs](#input\_jobs) | A map of Cloud Run jobs to create. | <pre>map(object({<br/>    image           = string<br/>    service_account = optional(string)<br/>    cpu             = optional(string, "1000m")<br/>    memory          = optional(string, "512Mi")<br/>    vpc_connector   = optional(string)<br/>    env_vars        = optional(map(string), {})<br/>    max_retries     = optional(number)<br/>    timeout         = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_services"></a> [services](#input\_services) | A map of Cloud Run services to create. | <pre>map(object({<br/>    image              = string<br/>    description        = optional(string)<br/>    service_account    = optional(string)<br/>    ingress            = optional(string, "INGRESS_TRAFFIC_ALL")<br/>    cpu                = optional(string, "1000m")<br/>    memory             = optional(string, "512Mi")<br/>    cpu_idle           = optional(bool, true)<br/>    vpc_connector      = optional(string)<br/>    min_instance_count = optional(number, 0)<br/>    max_instance_count = optional(number, 10)<br/>    invoker_members    = optional(list(string))<br/>    env_vars           = optional(map(string), {})<br/>    traffic = optional(list(object({<br/>      percent  = number<br/>      type     = optional(string, "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST")<br/>      revision = optional(string)<br/>      tag      = optional(string)<br/>    })), [])<br/><br/>    # Advanced Cloud Run v2 attributes<br/>    max_instance_request_concurrency = optional(number)<br/>    timeout                          = optional(string)<br/>    execution_environment            = optional(string) # EXECUTION_ENVIRONMENT_GEN1, EXECUTION_ENVIRONMENT_GEN2<br/>    binary_authorization = optional(object({<br/>      use_default = optional(bool)<br/>      policy      = optional(string)<br/>    }))<br/>    custom_audiences = optional(list(string))<br/><br/>    # Probe configuration<br/>    liveness_probe = optional(object({<br/>      initial_delay_seconds = optional(number)<br/>      timeout_seconds       = optional(number)<br/>      period_seconds        = optional(number)<br/>      failure_threshold     = optional(number)<br/>      http_get = optional(object({<br/>        path = optional(string)<br/>        port = optional(number)<br/>      }))<br/>    }))<br/>    startup_probe = optional(object({<br/>      initial_delay_seconds = optional(number)<br/>      timeout_seconds       = optional(number)<br/>      period_seconds        = optional(number)<br/>      failure_threshold     = optional(number)<br/>      http_get = optional(object({<br/>        path = optional(string)<br/>        port = optional(number)<br/>      }))<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_ids"></a> [job\_ids](#output\_job\_ids) | Map of Job names to their IDs |
| <a name="output_service_uris"></a> [service\_uris](#output\_service\_uris) | Map of Service names to their URIs |
<!-- END_TF_DOCS -->
