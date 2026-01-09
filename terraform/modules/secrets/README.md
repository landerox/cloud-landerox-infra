# Module: Secret Manager

Creates and manages secrets in Google Cloud Secret Manager. Supports automatic replication, IAM bindings, rotation policies, and Pub/Sub notifications.

## Features

- **Replication**:
  - `auto`: Replicates content to all available regions (default).
  - `user_managed`: Replicates to specific allowed regions.
- **Security**:
  - Customer Managed Encryption Keys (CMEK) support.
  - Granular IAM access control per secret.
- **Lifecycle**:
  - Automatic rotation schedules.
  - Pub/Sub notifications for secret events.
  - Initial version value management.
  - **Expiry (v7.x)**: Absolute `expire_time` or relative `ttl` for automatic deletion.
  - **Aliases (v7.x)**: Support for `version_aliases` (e.g. "prd" -> "1").

## Usage

```hcl
module "secrets" {
  source = "../../modules/secrets"

  project_id = var.project_id

  secrets = {
    "db-password" = {
      # Basic secret with auto-replication
      initial_value = "top-secret" # Only for initial creation
      
      accessors = [
        "serviceAccount:my-app-sa@my-project.iam.gserviceaccount.com"
      ]
    }

    "api-key-rotated" = {
      # Advanced configuration
      replication_type  = "user_managed"
      replica_locations = ["us-central1", "us-east1"]
      
      rotation_period    = "2592000s" # 30 days
      next_rotation_time = "2024-01-01T00:00:00Z"
      
      pubsub_topic = "projects/my-project/topics/secret-rotations"
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
| [google_project_service.secretmanager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.secrets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.accessors](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.versions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for secrets replication. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A map of secrets to create. | <pre>map(object({<br/>    replication_type   = optional(string, "auto")<br/>    replica_locations  = optional(list(string))<br/>    kms_key_name       = optional(string)<br/>    labels             = optional(map(string))<br/>    initial_value      = optional(string)<br/>    accessors          = optional(list(string))<br/>    rotation_period    = optional(string)<br/>    next_rotation_time = optional(string)<br/>    pubsub_topic       = optional(string)<br/><br/>    # Advanced Secret Manager attributes<br/>    expire_time     = optional(string)<br/>    ttl             = optional(string)<br/>    version_aliases = optional(map(string))<br/>    annotations     = optional(map(string))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | Map of secret names to their IDs |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names to their full resource names |
| <a name="output_secret_versions"></a> [secret\_versions](#output\_secret\_versions) | Map of secret names to their latest version IDs |
<!-- END_TF_DOCS -->
