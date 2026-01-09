# Module: Artifact Registry

Manages Artifact Registry repositories for storing build artifacts. Supports standard, remote (pull-through cache), and virtual repositories with advanced cleanup policies.

## Features

- **Formats**: Docker, Maven, NPM, Python (PyPI), Apt, Yum.
- **Repository Modes**:
  - `STANDARD_REPOSITORY`: Normal storage.
  - `REMOTE_REPOSITORY`: Pull-through cache for external upstreams (Docker Hub, Maven Central, etc.).
  - `VIRTUAL_REPOSITORY`: Aggregates multiple repositories behind a single endpoint.
- **Lifecycle Management**:
  - granular `cleanup_policies` to automatically delete old or untagged versions.
  - `cleanup_policy_dry_run` to test policies before enforcement.
  - `immutable_tags` to prevent overwriting releases.
- **Security**: 
  - Customer-Managed Encryption Keys (CMEK) support.
  - `vulnerability_scanning_config` for automatic scanning of images.

## Usage

```hcl
module "artifact_registry" {
  source = "../../modules/artifact_registry"

  project_id = var.project_id
  location   = "us-central1"

  repositories = {
    "app-images" = {
      format      = "DOCKER"
      description = "Application container images"
      
      docker_config = {
        immutable_tags = true
      }

      cleanup_policies = {
        "keep-release" = {
          action = "KEEP"
          condition = {
            tag_state    = "TAGGED"
            tag_prefixes = ["release-"]
          }
        }
        "delete-old-snapshots" = {
          action = "DELETE"
          condition = {
            tag_state  = "TAGGED"
            older_than = "2592000s" # 30 days
          }
        }
      }
    }

    "docker-hub-cache" = {
      format      = "DOCKER"
      mode        = "REMOTE_REPOSITORY"
      description = "Cache for Docker Hub"
      
      remote_repository_config = {
        docker_repository = {
          public_repository = "DOCKER_HUB"
        }
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
| [google_artifact_registry_repository.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The GCP region or multi-region for the repository. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | A map of Artifact Registry repositories to create. | <pre>map(object({<br/>    format       = string<br/>    description  = optional(string)<br/>    labels       = optional(map(string))<br/>    mode         = optional(string, "STANDARD_REPOSITORY") # STANDARD_REPOSITORY, REMOTE_REPOSITORY, VIRTUAL_REPOSITORY<br/>    kms_key_name = optional(string)<br/><br/>    cleanup_policy_dry_run = optional(bool)<br/><br/>    docker_config = optional(object({<br/>      immutable_tags = optional(bool, false)<br/>    }))<br/><br/>    remote_repository_config = optional(object({<br/>      description                 = optional(string)<br/>      disable_upstream_validation = optional(bool)<br/>      docker_repository = optional(object({<br/>        public_repository = optional(string) # DOCKER_HUB<br/>      }))<br/>      maven_repository = optional(object({<br/>        public_repository = optional(string) # MAVEN_CENTRAL<br/>      }))<br/>      npm_repository = optional(object({<br/>        public_repository = optional(string) # NPMJS<br/>      }))<br/>      python_repository = optional(object({<br/>        public_repository = optional(string) # PYPI<br/>      }))<br/>    }))<br/><br/>    virtual_repository_config = optional(object({<br/>      upstream_policies = optional(list(object({<br/>        id         = string<br/>        repository = string<br/>        priority   = number<br/>      })))<br/>    }))<br/><br/>    cleanup_policies = optional(map(object({<br/>      action = optional(string, "DELETE") # DELETE or KEEP<br/>      condition = optional(object({<br/>        tag_state             = optional(string) # TAGGED, UNTAGGED, ANY<br/>        tag_prefixes          = optional(list(string))<br/>        version_name_prefixes = optional(list(string))<br/>        package_name_prefixes = optional(list(string))<br/>        older_than            = optional(string) # e.g. "2592000s" (30 days)<br/>        newer_than            = optional(string)<br/>      }))<br/>      most_recent_versions = optional(object({<br/>        package_name_prefixes = optional(list(string))<br/>        keep_count            = optional(number)<br/>      }))<br/>    })))<br/><br/>    vulnerability_scanning_config = optional(object({<br/>      enablement_config = optional(string) # INHERITED, DISABLED<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repositories"></a> [repositories](#output\_repositories) | The created Artifact Registry repositories. |
<!-- END_TF_DOCS -->
