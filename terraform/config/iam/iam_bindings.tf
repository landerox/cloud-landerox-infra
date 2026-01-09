locals {
  project_iam_bindings = {
    # ===========================================================================
    # PROJECT IAM BINDINGS CONFIGURATION
    # ===========================================================================
    # Define generic project-level IAM bindings here (e.g. for Groups or Users).
    # Use the TEMPLATE below.

    # ===========================================================================
    # ACTIVE BINDINGS
    # ===========================================================================
    # "audit-group" = {
    #   role    = "roles/viewer"
    #   members = ["group:auditors@example.com"]
    # }

    # ===========================================================================
    # TEMPLATE: IAM Binding
    # ===========================================================================
    # "dummy-binding-id" = {
    #   role    = "roles/viewer"                # (Required) The role to assign.
    #   members = [                             # (Required) List of members.
    #     "user:jane@example.com",
    #     "group:devs@example.com",
    #     "serviceAccount:sa@project.iam.gserviceaccount.com"
    #   ]
    #
    #   condition = {                           # (Optional) IAM Condition
    #     title       = "Expires_After_2024"    # (Required) Title
    #     description = "Expiring access"       # (Optional) Description
    #     expression  = "request.time < timestamp(\"2024-01-01T00:00:00Z\")" # (Required) CEL expression
    #   }
    # }
  }
}
