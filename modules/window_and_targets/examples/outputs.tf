output "maintenance_window_target_id" {
  description = "Maintenance Window Target ID"
  value       = "${module.maint_window_target.maintenance_window_target_id}"
}

output "maintenance_window_id" {
  description = "Maintenance Window ID"
  value       = "${module.maint_window_target.maintenance_window_id}"
}
