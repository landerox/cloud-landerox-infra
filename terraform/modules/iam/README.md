# Module: IAM & Workload Identity

Manages Identity and Access Management (IAM) resources including Service Accounts, Workload Identity Pools (GitHub Actions), Custom Roles, and Project-level IAM bindings.

## Features

- **Service Accounts**: Create SAs with defined roles, descriptions, and **disabled** state support. Can handle pre-existing accounts via `create_ignore_already_exists`.
- **Workload Identity**: Configures WIF for GitHub Actions authentication. Supports **multiple repositories** mapped to specific service accounts. Pools and Providers can be **disabled** if needed.
- **Custom Roles**: Define custom IAM roles with specific permission sets.
- **Project Bindings**: Manage authoritative IAM bindings at the project level.
- **Impersonation**: Configure service account impersonation chains.

## Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  project_id = var.project_id

  # 1. Create Service Accounts
  service_accounts = {
    "sa-terraform" = {
      display_name = "Terraform CI"
      description  = "Infrastructure management"
      roles        = ["roles/editor"]
    }
    "sa-app-deploy" = {
      display_name = "App Deployment"
      description  = "Application CI/CD"
      roles        = ["roles/cloudfunctions.developer"]
    }
  }

  # 2. Configure Workload Identity (Multiple Repos)
  # Map specific GitHub repositories to specific Service Accounts
  wif_repositories = [
    {
      repo            = "my-org/infra-repo"
      service_account = "sa-terraform"
    },
    {
      repo            = "my-org/app-repo"
      service_account = "sa-app-deploy"
    }
  ]

  # 3. Define Custom Roles
  custom_roles = {
    "custom.dbViewer" = {
      title       = "Database Viewer"
      permissions = ["cloudsql.instances.get", "cloudsql.instances.list"]
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
| [google_iam_workload_identity_pool.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_custom_role.custom_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.project_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.wif_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Map of custom roles to create | <pre>map(object({<br/>    title       = string<br/>    description = optional(string)<br/>    permissions = list(string)<br/>    stage       = optional(string, "GA") # ALPHA, BETA, GA, DEPRECATED, EAP<br/>  }))</pre> | `{}` | no |
| <a name="input_project_iam_bindings"></a> [project\_iam\_bindings](#input\_project\_iam\_bindings) | Map of project-level IAM bindings (role -> members) | <pre>map(object({<br/>    role    = string<br/>    members = list(string)<br/>    condition = optional(object({<br/>      title       = string<br/>      description = optional(string)<br/>      expression  = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | GitHub repository ID (owner/repo) | `string` | `""` | no |
| <a name="input_sa_terraform_name"></a> [sa\_terraform\_name](#input\_sa\_terraform\_name) | The name of the Terraform service account. | `string` | `"sa-terraform"` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Service accounts to create with least-privilege roles | <pre>map(object({<br/>    display_name                 = string<br/>    description                  = optional(string)<br/>    roles                        = optional(list(string), [])<br/>    impersonation_users          = optional(list(string), [])<br/>    disabled                     = optional(bool, false)<br/>    create_ignore_already_exists = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_wif_pool_disabled"></a> [wif\_pool\_disabled](#input\_wif\_pool\_disabled) | Whether the Workload Identity Pool is disabled. | `bool` | `false` | no |
| <a name="input_wif_provider_disabled"></a> [wif\_provider\_disabled](#input\_wif\_provider\_disabled) | Whether the Workload Identity Pool Provider is disabled. | `bool` | `false` | no |
| <a name="input_wif_repositories"></a> [wif\_repositories](#input\_wif\_repositories) | List of GitHub repositories (owner/repo) allowed to assume identities via WIF | <pre>list(object({<br/>    repo            = string<br/>    service_account = string<br/>  }))</pre> | `[]` | no |
| <a name="input_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#input\_workload\_identity\_pool\_id) | The ID of the Workload Identity Pool. | `string` | `"github-pool"` | no |
| <a name="input_workload_identity_pool_provider_id"></a> [workload\_identity\_pool\_provider\_id](#input\_workload\_identity\_pool\_provider\_id) | The ID of the Workload Identity Pool Provider. | `string` | `"github-provider"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_emails"></a> [service\_account\_emails](#output\_service\_account\_emails) | Service account emails (for easy reference) |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | Created service accounts |
<!-- END_TF_DOCS -->
