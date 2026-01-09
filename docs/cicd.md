# CI/CD & Automation

This project uses **GitHub Actions** for all infrastructure changes, enforcing a GitOps workflow.

## Workflow Overview

We use three main workflows located in `.github/workflows/`:

| Workflow | File | Trigger | Description |
|----------|------|---------|-------------|
| **CI / Validation** | `ci.yml` | PRs, Push | Runs `pre-commit`, `terraform validate`, `checkov` (Security), and docs validation. No GCP credentials needed. |
| **Terraform** | `terraform.yml` | PRs, Push | **Plan:** On PRs. **Apply:** On merge to `main` (requires manual approval). Authenticates via WIF. |
| **Drift Detection** | `drift-detection.yml` | Weekly | Checks if actual infra differs from Terraform state. Creates an Issue if drift is found. |

## Deployment Strategy

### Single Environment (Current)

* **Branch:** `main`
* **Environment:** `prd` (Production)
* **Process:**
    1. PR -> Triggers `terraform plan`.
    2. Review Plan in PR comments.
    3. Merge -> Triggers `terraform apply`.
    4. **Approval:** A designated reviewer must approve the deployment in GitHub Environments.

## Configuration Management

We separate configuration into "Local" (Secret/Private) and "Production" (Public/Versioned).

| File | Context | Purpose | Git Tracked? |
|------|---------|---------|--------------|
| `terraform.tfvars` | Local | Private configuration (secrets, local overrides). | **NO** (.gitignore) |
| `config/prd.tfvars` | CI/CD | Public production settings (toggles, non-sensitive variables). | **YES** |

**Important:** When enabling a new module or changing a non-sensitive variable (like `owner`), you must update `terraform/config/prd.tfvars` so the CI/CD pipeline sees the change.

## Authentication (Workload Identity)

We do **not** use long-lived Service Account JSON keys. Instead, we use **Workload Identity Federation (WIF)**.

1. GitHub Actions requests an OIDC token from GitHub.
2. It exchanges this token with GCP Security Token Service.
3. It impersonates a Service Account based on the repository origin.

### Multi-Repository Support

The WIF configuration supports trusting multiple repositories with granular permissions:

* **Infra Repo (`this`):** Authenticates as `sa-terraform` (Admin privileges).
* **App Repos:** Authenticate as `sa-deployment` (Deploy privileges only).

### Required GitHub Variables

Configure these in **Settings > Secrets and variables > Actions > Variables**:

* `GCP_PROJECT_ID`
* `GCP_STATE_BUCKET`

### Required GitHub Secrets

Configure these in **Settings > Secrets and variables > Actions > Secrets**:

* `GCP_WIF_PROVIDER` (Full path: `projects/.../providers/...`)
* `GCP_WIF_SERVICE_ACCOUNT_EMAIL` (The specific SA for that repo)

## Policy as Code

Every Plan is scanned by **Checkov** and **Conftest** before it can be applied.

* Security violations will block the PR (unless marked as soft-fail).
* See `terraform/policies/checkov/.checkov.yaml` for configuration.
