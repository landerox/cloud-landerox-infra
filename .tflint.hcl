# =============================================================================
# TFLint Configuration
# =============================================================================
#
# TFLint is a Terraform linter that checks for possible errors, best practices,
# and naming conventions.
#
# Usage:
#   tflint --init
#   tflint
#
# =============================================================================

config {
  plugin_dir = "~/.tflint.d/plugins"

  # Enables module inspection
  call_module_type = "local"
}

# =============================================================================
# Google Cloud Plugin
# =============================================================================

plugin "google" {
  enabled = true
  version = "0.27.1"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}

# =============================================================================
# Terraform Plugin (built-in rules)
# =============================================================================

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# =============================================================================
# Custom Rules
# =============================================================================

# Enforce consistent naming conventions
rule "terraform_naming_convention" {
  enabled = true

  variable {
    format = "snake_case"
  }

  locals {
    format = "snake_case"
  }

  output {
    format = "snake_case"
  }

  resource {
    format = "snake_case"
  }

  module {
    format = "snake_case"
  }

  data {
    format = "snake_case"
  }
}

# Require descriptions for variables
rule "terraform_documented_variables" {
  enabled = true
}

# Require descriptions for outputs
rule "terraform_documented_outputs" {
  enabled = true
}

# Prevent deprecated syntax
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Require type declarations for variables
rule "terraform_typed_variables" {
  enabled = true
}

# Disallow legacy dot index syntax
rule "terraform_deprecated_index" {
  enabled = true
}

# Warn about unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}

# Enforce standard module structure
rule "terraform_standard_module_structure" {
  enabled = true
}
