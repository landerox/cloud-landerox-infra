output "service_uris" {
  description = "Map of Service names to their URIs"
  value       = { for k, v in google_cloud_run_v2_service.services : k => v.uri }
}

output "job_ids" {
  description = "Map of Job names to their IDs"
  value       = { for k, v in google_cloud_run_v2_job.jobs : k => v.id }
}
