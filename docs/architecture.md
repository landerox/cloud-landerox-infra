# Architecture & Design

This document describes the architectural decisions and structure of the Landerox Cloud Infra.

## Configuration Philosophy

This project uses a **Configuration Pattern** that strictly separates reusable module logic from resource definitions:

| What | Where | Description |
|------|-------|-------------|
| **Environment values** | `terraform.tfvars` | Project ID, region, module toggles. |
| **Resource definitions** | `config/<module>/*.tf` | Instantiation of resources (Buckets, Service Accounts, etc.). |
| **Module logic** | `modules/*/` | Reusable Terraform modules (Source code). |

### Why This Pattern?

- **Auditable**: Every infrastructure change is tracked in Git history.
- **Reviewable**: Pull requests show exactly what resources will change.
- **Modular**: Logic is separated from configuration, allowing for cleaner updates.
- **Maintainable**: Reduces code duplication.
- **Multi-Tenant Ready**: Designed to host multiple independent initiatives (Data, AI, Web) within the same core infrastructure.

## Directory Structure

```bash
terraform/
├── main.tf                      # Root module - orchestrates config templates
├── versions.tf                  # Terraform and provider version constraints
├── variables.tf                 # Environment variables
├── outputs.tf                   # Output value definitions
├── providers.tf                 # Google provider configuration
├── backend.tf                   # GCS remote state backend
├── Justfile                     # Task runner
├── terraform.tfvars             # Local environment values (git-ignored)
│
├── policies/                    # Policy as Code (Checkov & Conftest)
│
├── modules/                     # Reusable module implementations (Provider v7.x)
│   ├── iam/                     # Service accounts, WIF
│   ├── storage/                 # GCS buckets (Soft Delete, Hierarchical Namespace)
│   ├── networking/              # VPC, subnets, firewall
│   ├── monitoring/              # Cloud Logging
│   ├── secrets/                 # Secret Manager (TTL, Version Aliases)
│   └── artifact_registry/       # Repositories (Cleanup Policies, Scanning)
│
└── config/                      # Resource definitions (The "Live" Infra)
    ├── prd.tfvars               # Production environment settings
    ├── iam/
    ├── storage/
    ├── networking/
    ├── monitoring/
    ├── secrets/
    └── artifact_registry/
```

## Module Reference

The following modules are available and configured for **Google Provider 7.x**:

| Module | Description | Config Directory |
|--------|-------------|------------------|
| **IAM** | Service Accounts, IAM Bindings, Workload Identity. | `config/iam/` |
| **Storage** | GCS Buckets with Soft Delete and Hierarchical Namespace. | `config/storage/` |
| **Networking** | VPC, Subnets, Firewall Rules, NAT. | `config/networking/` |
| **Monitoring** | Logging buckets, Notification channels. | `config/monitoring/` |
| **Secrets** | Secret Manager with TTL and Version Aliases. | `config/secrets/` |
| **Scheduler** | Cloud Scheduler jobs (HTTP/PubSub). | `config/scheduler/` |
| **Artifact Registry** | Repositories with Cleanup Policies and Scanning. | `config/artifact_registry/` |
| **BigQuery** | Datasets, Tables, Views and Routines. | `config/bigquery/` |
| **Cloud Run** | Serverless services (V2) with health probes. | `config/cloud_run/` |

## Deployment & Security

- **Identities:**
  - `sa-deployment`: Used by CI/CD pipelines to build and deploy services.
  - `sa-functions`: Used by Cloud Functions at runtime (least privilege access).
  - `sa-dataflow`: Used by Dataflow workers during pipeline execution.
- **Security:** Workload Identity Federation (WIF) allows secure, keyless deployments from trusted external repositories.
