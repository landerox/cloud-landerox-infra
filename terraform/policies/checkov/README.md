# Checkov Policies

This directory contains Checkov configuration and custom policies for security scanning.

## Files

| File | Purpose |
|------|---------|
| `.checkov.yaml` | Main Checkov configuration |
| `custom/` | Custom policy definitions (optional) |

## Configuration

The `.checkov.yaml` file controls:

- **skip-check**: Policies to skip (with justification)
- **soft-fail**: Whether to fail builds on violations
- **external-checks-dir**: Path to custom policies

## Adding Custom Policies

Checkov supports custom policies in YAML or Python format.

### YAML Policy Example

Create a file in `custom/` directory:

```yaml
# custom/naming-convention.yaml
metadata:
  id: "CUSTOM_GCP_001"
  name: "Ensure GCS buckets follow naming convention"
  category: "convention"
  severity: "medium"

definition:
  cond_type: "attribute"
  resource_types:
    - "google_storage_bucket"
  attribute: "name"
  operator: "regex_match"
  value: "^(dev|tst|prd)-[a-z]+-[a-z0-9-]+$"
```

### Python Policy Example

```python
# custom/check_bucket_naming.py
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckResult, CheckCategories

class BucketNamingConvention(BaseResourceCheck):
    def __init__(self):
        name = "Ensure GCS bucket follows naming convention"
        id = "CUSTOM_GCP_001"
        supported_resources = ["google_storage_bucket"]
        categories = [CheckCategories.CONVENTION]
        super().__init__(name=name, id=id, categories=categories,
                        supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        name = conf.get("name", [""])[0]
        import re
        if re.match(r"^(dev|tst|prd)-[a-z]+-[a-z0-9-]+$", name):
            return CheckResult.PASSED
        return CheckResult.FAILED

check = BucketNamingConvention()
```

## Skipping Checks

To skip a check, add it to `.checkov.yaml` with justification:

```yaml
skip-check:
  - CKV_GCP_XX  # Justification: <business reason>
```

## Running Locally

```bash
# Run Checkov with config
checkov -d terraform/ --config-file terraform/policies/checkov/.checkov.yaml

# Run specific check
checkov -d terraform/ --check CKV_GCP_62

# List all GCP checks
checkov --list | grep GCP
```

## References

- [Checkov Documentation](https://www.checkov.io/)
- [GCP Policy Index](https://www.checkov.io/5.Policy%20Index/terraform.html)
- [Custom Policies Guide](https://www.checkov.io/3.Custom%20Policies/Custom%20Policies%20Overview.html)
