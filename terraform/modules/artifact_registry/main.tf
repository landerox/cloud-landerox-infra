# terraform/modules/artifact_registry/main.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_artifact_registry_repository" "this" {
  for_each = var.repositories

  project       = var.project_id
  location      = var.location
  repository_id = each.key
  description   = try(each.value.description, "Managed by Terraform")
  format        = each.value.format
  labels        = merge(var.labels, try(each.value.labels, {}))
  mode          = each.value.mode
  kms_key_name  = each.value.kms_key_name

  cleanup_policy_dry_run = try(each.value.cleanup_policy_dry_run, null)

  dynamic "docker_config" {
    for_each = each.value.docker_config != null ? [each.value.docker_config] : []
    content {
      immutable_tags = docker_config.value.immutable_tags
    }
  }

  dynamic "remote_repository_config" {
    for_each = each.value.remote_repository_config != null ? [each.value.remote_repository_config] : []
    content {
      description                 = remote_repository_config.value.description
      disable_upstream_validation = remote_repository_config.value.disable_upstream_validation

      dynamic "docker_repository" {
        for_each = remote_repository_config.value.docker_repository != null ? [remote_repository_config.value.docker_repository] : []
        content {
          public_repository = docker_repository.value.public_repository
        }
      }
      dynamic "maven_repository" {
        for_each = remote_repository_config.value.maven_repository != null ? [remote_repository_config.value.maven_repository] : []
        content {
          public_repository = maven_repository.value.public_repository
        }
      }
      dynamic "npm_repository" {
        for_each = remote_repository_config.value.npm_repository != null ? [remote_repository_config.value.npm_repository] : []
        content {
          public_repository = npm_repository.value.public_repository
        }
      }
      dynamic "python_repository" {
        for_each = remote_repository_config.value.python_repository != null ? [remote_repository_config.value.python_repository] : []
        content {
          public_repository = python_repository.value.public_repository
        }
      }
    }
  }

  dynamic "virtual_repository_config" {
    for_each = each.value.virtual_repository_config != null ? [each.value.virtual_repository_config] : []
    content {
      dynamic "upstream_policies" {
        for_each = virtual_repository_config.value.upstream_policies != null ? virtual_repository_config.value.upstream_policies : []
        content {
          id         = upstream_policies.value.id
          repository = upstream_policies.value.repository
          priority   = upstream_policies.value.priority
        }
      }
    }
  }

  dynamic "cleanup_policies" {
    for_each = each.value.cleanup_policies != null ? each.value.cleanup_policies : {}
    content {
      id     = cleanup_policies.key
      action = cleanup_policies.value.action

      dynamic "condition" {
        for_each = cleanup_policies.value.condition != null ? [cleanup_policies.value.condition] : []
        content {
          tag_state             = condition.value.tag_state
          tag_prefixes          = condition.value.tag_prefixes
          version_name_prefixes = condition.value.version_name_prefixes
          package_name_prefixes = condition.value.package_name_prefixes
          older_than            = condition.value.older_than
          newer_than            = condition.value.newer_than
        }
      }

      dynamic "most_recent_versions" {
        for_each = cleanup_policies.value.most_recent_versions != null ? [cleanup_policies.value.most_recent_versions] : []
        content {
          package_name_prefixes = most_recent_versions.value.package_name_prefixes
          keep_count            = most_recent_versions.value.keep_count
        }
      }
    }
  }

  dynamic "vulnerability_scanning_config" {
    for_each = each.value.vulnerability_scanning_config != null ? [each.value.vulnerability_scanning_config] : []
    content {
      enablement_config = vulnerability_scanning_config.value.enablement_config
    }
  }
}
