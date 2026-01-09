output "bucket_names" {
  description = "Map of bucket names created"
  value       = module.storage_buckets.bucket_names
}

output "bucket_urls" {
  description = "Map of bucket URLs"
  value       = module.storage_buckets.bucket_urls
}
