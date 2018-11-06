output "maintenance_window_target_id" {
  description = "Maintenance Window Target ID"
  value       = "${aws_ssm_maintenance_window_target.maintenance_window_target.id}"
}

output "maintenance_window_id" {
  description = "Maintenance Window ID"
  value       = "${aws_ssm_maintenance_window.maintenance_window.id}"
}
