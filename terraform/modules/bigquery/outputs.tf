output "dataset_ids" {
  description = "IDs of the created BigQuery datasets."
  value       = module.datasets.dataset_ids
}

output "table_ids" {
  description = "IDs of the created BigQuery tables."
  value       = module.tables.table_ids
}

output "view_ids" {
  description = "IDs of the created BigQuery views."
  value       = module.views.view_ids
}

output "routine_ids" {
  description = "IDs of the created BigQuery routines."
  value       = module.routines.routine_ids
}
