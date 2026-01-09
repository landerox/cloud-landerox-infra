# Governance & Compliance

This document outlines the standards for resource tagging, security policies, and compliance controls.

## Governance Labels

All resources created by this framework automatically receive a standard set of labels. This helps in cost tracking and ownership identification.

### Configuration

Labels are defined globally in `terraform.tfvars`:

```hcl
cost_center         = "shared-services"
owner               = "platform-team"
data_classification = "internal"      # public, internal, confidential, restricted
compliance_scope    = "soc2"          # none, soc2, pci-dss, hipaa
```

### How It Works

1. Variables are passed to the `main.tf` root module.
2. A local `all_labels` map is constructed, merging these governance labels with `managed_by = "terraform"`.
3. Every module receives `labels = local.all_labels` and applies them to every resource.

## Labels vs Tags

This framework supports two types of metadata:

1. **Labels**: Key-value pairs used for cost tracking and grouping. Applied to almost all resources.
2. **Resource Tags (Advanced)**: IAM-based tags that can be used for granular access control policies (e.g., restricted access to buckets tagged with `classification:confidential`). Available in modern modules (Storage, BigQuery, AR).

## Security Controls

### Storage

* **Public Access Prevention:** Enforced globally.
* **Uniform Bucket Access:** Mandatory for all buckets.
* **Versioning:** Configurable, but recommended for state and critical data.

### IAM

* **Least Privilege:** Service Accounts are created with specific roles, avoiding primitive roles (`Owner`, `Editor`) where possible.
* **No Keys:** User-managed keys are discouraged in favor of Workload Identity.

### Secrets

* **Replication:** Automatic replication is enabled by default for high availability.
* **Access Control:** Only specific Service Accounts (defined in `secrets.tf`) can access secret payloads.
