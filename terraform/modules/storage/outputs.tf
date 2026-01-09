output "bucket_names" {
  description = "Created storage bucket names"
  value = {
    for name, bucket in google_storage_bucket.buckets :
    name => bucket.name
  }
}

output "bucket_self_links" {
  description = "Self links of created buckets"
  value = {
    for name, bucket in google_storage_bucket.buckets :
    name => bucket.self_link
  }
}

output "bucket_urls" {
  description = "URLs of created buckets"
  value = {
    for name, bucket in google_storage_bucket.buckets :
    name => "gs://${bucket.name}"
  }
}
