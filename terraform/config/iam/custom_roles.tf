locals {
  custom_roles = {
    # ===========================================================================
    # CUSTOM ROLES CONFIGURATION
    # ===========================================================================
    # Define custom IAM roles here.
    # Use the TEMPLATE below.

    # ===========================================================================
    # ACTIVE ROLES
    # ===========================================================================
    # "my-custom-role" = {
    #   title       = "My Custom Role"
    #   permissions = ["resourcemanager.projects.get"]
    # }

    # ===========================================================================
    # TEMPLATE: Custom Role
    # ===========================================================================
    # "dummy-role-id" = {
    #   title       = "My Custom Role Title"    # (Required) Human readable title.
    #   description = "Description of purpose"  # (Optional) Description.
    #   stage       = "GA"                      # (Optional) Default: GA. Options: [ALPHA, BETA, GA, DEPRECATED]
    #
    #   permissions = [                         # (Required) List of permissions
    #     "resourcemanager.projects.get",
    #     "storage.buckets.get",
    #     "storage.objects.list"
    #   ]
    # }
  }
}
