# Module: Storage

Manages Google Cloud Storage buckets with support for modern features, lifecycle policies, versioning, logging, CMEK encryption, and advanced compliance.

## Features

- Uniform bucket-level access (default: enabled)
- Public access prevention (default: enforced)
- Object versioning
- Access logging with auto-created log buckets
- Lifecycle rules (Delete, SetStorageClass)
- Customer-managed encryption keys (CMEK)
- Retention policies with optional locking
- CORS configuration
- **Advanced (v7.x):** Hierarchical Namespace support
- **Advanced (v7.x):** Soft Delete Policy for data recovery
- **Advanced (v7.x):** Autoclass for automated storage class transitions
- **Advanced (v7.x):** Custom Placement Config for dual-region setup

## Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  labels      = var.labels

  buckets = {
    "my-data-bucket" = {
      location           = "US"
      storage_class      = "STANDARD"
      versioning_enabled = true

      soft_delete_policy = {
        retention_duration_seconds = 604800 # 7 days
      }

      enable_lifecycle = true
      lifecycle_rules = [
        {
          action_type        = "Delete"
          num_newer_versions = 3
          is_live            = false
        }
      ]
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
| [google_project_service.storage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_storage_bucket.buckets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name (e.g., prd, dev). | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the buckets. | `string` | n/a | yes |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | A map of buckets to create. | <pre>map(object({<br/>    location                 = optional(string)<br/>    storage_class            = optional(string, "STANDARD")<br/>    uniform_access           = optional(bool, true)<br/>    versioning_enabled       = optional(bool, false)<br/>    public_access_prevention = optional(string, "enforced")<br/>    enable_logging           = optional(bool, false)<br/>    enable_lifecycle         = optional(bool, false)<br/>    labels                   = optional(map(string))<br/><br/>    encryption = optional(object({<br/>      default_kms_key_name = string<br/>    }))<br/><br/>    retention_policy = optional(object({<br/>      retention_period = number<br/>      is_locked        = optional(bool, false)<br/>    }))<br/><br/>    cors = optional(list(object({<br/>      origin          = list(string)<br/>      method          = list(string)<br/>      response_header = list(string)<br/>      max_age_seconds = number<br/>    })))<br/><br/>    lifecycle_rules = optional(list(object({<br/>      action_type                = string<br/>      action_storage_class       = optional(string)<br/>      age_days                   = optional(number)<br/>      matches_storage_class      = optional(list(string))<br/>      num_newer_versions         = optional(number)<br/>      days_since_noncurrent_time = optional(number)<br/>      is_live                    = optional(bool)<br/>    })))<br/><br/>    # New advanced attributes for Google Provider 7.x<br/>    soft_delete_policy = optional(object({<br/>      retention_duration_seconds = optional(number)<br/>    }))<br/><br/>    autoclass = optional(object({<br/>      enabled                = bool<br/>      terminal_storage_class = optional(string)<br/>    }))<br/><br/>    hierarchical_namespace = optional(object({<br/>      enabled = bool<br/>    }))<br/><br/>    custom_placement_config = optional(object({<br/>      data_locations = list(string)<br/>    }))<br/><br/>    website = optional(object({<br/>      main_page_suffix = optional(string)<br/>      not_found_page   = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_names"></a> [bucket\_names](#output\_bucket\_names) | Created storage bucket names |
| <a name="output_bucket_self_links"></a> [bucket\_self\_links](#output\_bucket\_self\_links) | Self links of created buckets |
| <a name="output_bucket_urls"></a> [bucket\_urls](#output\_bucket\_urls) | URLs of created buckets |
<!-- END_TF_DOCS -->
