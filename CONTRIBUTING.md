# Contributing

This is a private repository. Contributions are made directly via branches and Pull Requests.

## How to Contribute

1. **Create a branch:** Use a descriptive name (e.g., `feat/add-storage-bucket` or `fix/iam-permissions`).
2. **Follow Conventional Commits:** Use prefixes like `feat:`, `fix:`, `chore:`, `docs:`, etc.
3. **Local Validation:** Always run validation locally before pushing.
4. **Pull Request:** Open a PR toward the `main` branch.

## Local Development

All operations are managed via `just` from the `terraform/` directory.

```bash
cd terraform

# 1. Initialize environment
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your GCP values

# 2. Local validation
just fmt      # Format code
just validate # Validate syntax
just plan     # Preview changes
```

## Standards

- **Conventional Commits:** Mandatory for all commits.
- **Terraform Formatting:** Code must be formatted using `terraform fmt`.
- **Modularity:** Use existing modules from `terraform/modules/`.
- **Variables:** Always provide clear descriptions for new variables.

## Pull Request Process

1. Ensure the Terraform Plan in the CI passes without errors.
2. Review the Plan output to confirm only intended changes are occurring.
3. Merge the PR after review (if applicable) or manual validation.
4. Apply occurs automatically or after approval in the GitHub Environment.
