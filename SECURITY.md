# Security Policy

## Reporting a Vulnerability

As this is a private repository, please report any security vulnerabilities directly to the project maintainers.

## Scope

This repository contains infrastructure-as-code (IaC) for the **Landerox Cloud Infra** GCP environment. Security priorities include:

- **Secret Management:** Never commit secrets to the repository. Use GCP Secret Manager or sensitive variables (handled via `.tfvars` which are ignored).
- **Least Privilege:** Follow the principle of least privilege for all Service Accounts and IAM bindings.
- **State Protection:** Terraform state is stored securely in a GCS bucket with versioning and encryption.
- **WIF Authentication:** GitHub Actions use Workload Identity Federation to avoid using long-lived service account keys.

## Security Best Practices

1. **Uniform Bucket Access:** Enforced on all GCS buckets.
2. **Public Access Prevention:** Enforced at the organization/project level and on individual buckets.
3. **KMS Encryption:** Use Cloud KMS for sensitive data encryption at rest where required.
4. **Audit Logs:** Ensure Cloud Audit Logs are enabled for resource modifications.
5. **Vulnerability Scanning:** CI/CD pipelines run `checkov` on every Pull Request to detect insecure configurations.
