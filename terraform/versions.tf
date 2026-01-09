# =============================================================================
# Terraform and Provider Version Constraints
# =============================================================================
#
# This file defines version constraints for Terraform and all providers.
# Pinning versions ensures reproducible builds and prevents unexpected
# breaking changes from provider updates.
#
# Version Policy:
#   - Terraform: Minor version pinned (e.g., >= 1.6, < 2.0)
#   - Providers: Pessimistic constraint (~>) for patch updates only
#
# Update Process:
#   1. Review provider changelog for breaking changes
#   2. Update version constraints in this file
#   3. Run `terraform init -upgrade`
#   4. Test changes in non-production environment
#   5. Submit PR for review
#
# =============================================================================

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
