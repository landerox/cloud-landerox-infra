output "job_ids" {
  description = "The IDs of the Cloud Scheduler jobs created."
  value       = try(module.scheduler.job_ids, {})
}
