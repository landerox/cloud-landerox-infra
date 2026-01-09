# Terraform Configuration

This directory contains the Infrastructure as Code (IaC) definitions for the Landerox Cloud Infra project.

## Documentation Index

For detailed guides, please refer to the `../docs/` directory:

* **[Architecture & Modules](../docs/architecture.md)**: Understanding the folder structure and available modules.
* **[Development Guide](../docs/development.md)**: Local setup, daily commands, and "How-To" guides for adding resources.
* **[CI/CD & Automation](../docs/cicd.md)**: Explanation of GitHub Actions workflows and Workload Identity.
* **[Governance](../docs/governance.md)**: Labeling standards and security policies.

---

## Technical Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 7.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.9 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_artifact_registry"></a> [artifact\_registry](#module\_artifact\_registry) | ./config/artifact_registry | n/a |
| <a name="module_bigquery_datasets"></a> [bigquery\_datasets](#module\_bigquery\_datasets) | ./config/bigquery/datasets | n/a |
| <a name="module_cloud_run"></a> [cloud\_run](#module\_cloud\_run) | ./config/cloud_run | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./config/iam | n/a |
| <a name="module_scheduler"></a> [scheduler](#module\_scheduler) | ./config/scheduler | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./config/secrets | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./config/storage | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [time_sleep.wait_for_iam](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_state_bucket"></a> [state\_bucket](#input\_state\_bucket) | Name of the GCS bucket for Terraform state (used by Justfile) | `string` | n/a | yes |
| <a name="input_compliance_scope"></a> [compliance\_scope](#input\_compliance\_scope) | Compliance scope (none, soc2, pci-dss, hipaa) | `string` | `"none"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center for billing and reporting | `string` | `"shared-services"` | no |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Data classification level (public, internal, confidential, restricted) | `string` | `"internal"` | no |
| <a name="input_enable_artifact_registry_module"></a> [enable\_artifact\_registry\_module](#input\_enable\_artifact\_registry\_module) | Enable Artifact Registry module | `bool` | `false` | no |
| <a name="input_enable_bigquery_module"></a> [enable\_bigquery\_module](#input\_enable\_bigquery\_module) | Enable BigQuery module | `bool` | `false` | no |
| <a name="input_enable_cloud_run_module"></a> [enable\_cloud\_run\_module](#input\_enable\_cloud\_run\_module) | Enable Cloud Run module | `bool` | `false` | no |
| <a name="input_enable_iam_module"></a> [enable\_iam\_module](#input\_enable\_iam\_module) | Enable IAM module | `bool` | `true` | no |
| <a name="input_enable_scheduler_module"></a> [enable\_scheduler\_module](#input\_enable\_scheduler\_module) | Enable Cloud Scheduler module | `bool` | `false` | no |
| <a name="input_enable_secrets_module"></a> [enable\_secrets\_module](#input\_enable\_secrets\_module) | Enable Secret Manager module | `bool` | `false` | no |
| <a name="input_enable_storage_module"></a> [enable\_storage\_module](#input\_enable\_storage\_module) | Enable Storage module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (none, dev, tst, prd). Use 'none' for single-environment projects. | `string` | `"none"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to all resources | `map(string)` | <pre>{<br/>  "created_by": "terraform",<br/>  "managed_by": "terraform"<br/>}</pre> | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the resources (team or individual) | `string` | `"platform-team"` | no |
| <a name="input_region"></a> [region](#input\_region) | Default GCP region | `string` | `"us-central1"` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | GitHub repository ID (owner/repo) | `string` | `""` | no |
| <a name="input_state_bucket_class"></a> [state\_bucket\_class](#input\_state\_bucket\_class) | Storage class for state bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE) | `string` | `"STANDARD"` | no |
| <a name="input_wif_repositories"></a> [wif\_repositories](#input\_wif\_repositories) | List of GitHub repositories (owner/repo) allowed to assume identities via WIF | <pre>list(object({<br/>    repo            = string<br/>    service_account = string<br/>  }))</pre> | `[]` | no |
| <a name="input_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#input\_workload\_identity\_pool\_id) | Workload Identity Pool ID | `string` | `"github-pool"` | no |
| <a name="input_workload_identity_pool_provider_id"></a> [workload\_identity\_pool\_provider\_id](#input\_workload\_identity\_pool\_provider\_id) | Workload Identity Provider ID | `string` | `"github-provider"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_registry_outputs"></a> [artifact\_registry\_outputs](#output\_artifact\_registry\_outputs) | Artifact Registry module outputs |
| <a name="output_bigquery_outputs"></a> [bigquery\_outputs](#output\_bigquery\_outputs) | BigQuery module outputs |
| <a name="output_cloud_run_outputs"></a> [cloud\_run\_outputs](#output\_cloud\_run\_outputs) | Cloud Run module outputs |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name |
| <a name="output_iam_outputs"></a> [iam\_outputs](#output\_iam\_outputs) | IAM module outputs |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | GCP Project ID |
| <a name="output_region"></a> [region](#output\_region) | GCP Region |
| <a name="output_scheduler_outputs"></a> [scheduler\_outputs](#output\_scheduler\_outputs) | Cloud Scheduler module outputs |
| <a name="output_secrets_outputs"></a> [secrets\_outputs](#output\_secrets\_outputs) | Secrets module outputs |
| <a name="output_storage_outputs"></a> [storage\_outputs](#output\_storage\_outputs) | Outputs from the storage module. |
<!-- END_TF_DOCS -->
