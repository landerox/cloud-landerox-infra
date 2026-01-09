# backend.tf
#
# State is stored in GCS. The bucket is configured at init time:
#   terraform init -backend-config="bucket=STATE_BUCKET_NAME"
#
# The state bucket is created by 'just bootstrap' before first init.

terraform {
  backend "gcs" {
    prefix = "terraform/state"
    # bucket is configured via -backend-config flag
  }
}
