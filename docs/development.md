# Development Guide

This guide covers local setup, daily workflows, and specific "How-To" instructions for adding resources.

## Getting Started

### Prerequisites

| Tool | Purpose |
|------|---------|
| **Terraform** (v1.10.x) | Infrastructure provisioning. |
| **Google Cloud SDK** | Authentication and CLI commands. |
| **Just** | Command runner for standardizing tasks. |
| **terraform-docs** (v0.19+) | Automated documentation generation. |
| **TFLint** | (Optional) Linter for Terraform. |

### Initial Setup

1. **Configure Environment**:

    ```bash
    cd terraform
    cp terraform.tfvars.example terraform.tfvars
    # Edit terraform.tfvars with your Project ID and State Bucket
    ```

2. **Bootstrap (One-time only)**:

    ```bash
    just bootstrap
    ```

    This sets up the State Bucket, enables **essential** APIs (IAM, Resource Manager), and configures Workload Identity. All other project APIs (BigQuery, Run, etc.) are managed via `terraform apply`.

## Daily Workflow

All commands should be run from the `terraform/` directory.

| Command | Description |
|---------|-------------|
| `just fmt` | Format all Terraform files (Run before every commit). |
| `just validate` | Validate configuration syntax. |
| `just plan` | Generate a speculative execution plan locally. |
| `just docs` | Regenerate README files for all modules. |
| `just lint` | Run static analysis (requires tflint). |

**Standard Process:**

1. Create a new branch (`feat/...`).
2. Modify `.tf` files in `config/`.
3. Run `just fmt && just validate`.
4. Run `just plan` to verify logic.
5. Commit and Push.

**Note:** If you enable a new module (e.g., set `enable_cloud_run_module = true`) in your local `terraform.tfvars`, remember to also update `terraform/config/prd.tfvars` so the change applies in the CI/CD pipeline.

## How-To Guides

### How to Add a New GCS Bucket

1. Edit `terraform/config/storage/buckets.tf`.
2. Add to the `locals.buckets` map:

    ```hcl
    "new-feature-bucket" = {
      location       = "US"
      storage_class  = "STANDARD"
      uniform_access = true
    }
    ```

    **Tip:** Use `${var.project_id}-` as a prefix for the key if you need global uniqueness (e.g., `"${var.project_id}-my-bucket"`).

### How to Create a Service Account

1. Edit `terraform/config/iam/service_accounts.tf`.
2. Add to `locals.service_accounts`:

    ```hcl
    "sa-my-app" = {
      display_name = "My App Service Account"
      description  = "Used by the backend application"
      roles        = ["roles/storage.objectViewer", "roles/bigquery.dataEditor"]
    }
    ```

### How to Add a Secret

1. Edit `terraform/config/secrets/secrets.tf`.
2. Define the secret container:

    ```hcl
    "api-key-external" = {
      replication_type = "auto"
      accessors        = ["serviceAccount:sa-my-app@PROJECT_ID.iam.gserviceaccount.com"]
    }
    ```

3. Apply changes via PR.
4. Add the secret value manually or via CLI (Terraform manages the container, not the value):

    ```bash
    echo -n "SUPER_SECRET_VALUE" | gcloud secrets versions add api-key-external --data-file=-
    ```

### How to Enable a GCP API

All GCP services must be explicitly managed by Terraform to prevent configuration drift.

1. Edit `terraform/apis.tf`.
2. Add the service endpoint to the `local.services` list (alphabetically):

    ```hcl
    locals {
      services = [
        # ...
        "redis.googleapis.com", # New service
      ]
    }
    ```

3. Run `just plan` to verify.
4. Commit and push. **Do not** use `gcloud services enable` manually (except for bootstrapping).

## Troubleshooting

### Bucket already exists (409)

Bucket names are globally unique across all of Google Cloud.

* **Fix:** Change the key name in `buckets.tf` to be more unique (e.g., prefix with project ID).

### Access Denied (403)

* Check your local login: `gcloud auth application-default login`.
* Ensure your user has `Owner` or `Editor` role on the project.

### App Engine Creation Error (403)

If you see `Permission 'appengine.applications.create' denied` despite having the role:

* **Cause:** IAM propagation delay (Race condition).
* **Fix:** The root module includes a `time_sleep` resource (60s) to handle this automatically. If it persists locally, wait 1-2 minutes and retry.

### State Lock Error

If a previous command crashed, the state might be locked.

* **Fix:** Wait 15 minutes or use `terraform force-unlock <LOCK_ID>` (Use with extreme caution).
