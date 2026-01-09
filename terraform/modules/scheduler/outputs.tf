output "job_ids" {
  description = "Map of job names to their IDs"
  value = {
    for name, job in google_cloud_scheduler_job.jobs : name => job.id
  }
}

output "job_names" {
  description = "Map of job names to their full resource names"
  value = {
    for name, job in google_cloud_scheduler_job.jobs : name => job.name
  }
}

output "app_engine_location" {
  description = "App Engine application location (if created)"
  value       = var.create_app_engine ? var.app_engine_location : null
}
