output "maintenance_window_target_id" {
  description = "Maintenance Window Target ID"
  value       = module.maint_window_target.maintenance_window_target_id
}

output "maintenance_window_id" {
  description = "Maintenance Window ID"
  value       = module.maint_window_target.maintenance_window_id
}

output "maintenance_window_task_1_id" {
  description = "Maintenance Window Task 1 ID"
  value       = module.maintenance_window_task_1.maintenance_window_task_id
}

output "maintenance_window_task_2_id" {
  description = "Maintenance Window Task 2 ID"
  value       = module.maintenance_window_task_2.maintenance_window_task_id
}

