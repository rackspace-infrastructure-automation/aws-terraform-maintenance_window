output "maintenance_window_task_id" {
  value = "${element(coalescelist(aws_ssm_maintenance_window_task.maintenance_window_task_no_logging.*.id, aws_ssm_maintenance_window_task.maintenance_window_task_with_logging.*.id, list("")), 0)}"
}
