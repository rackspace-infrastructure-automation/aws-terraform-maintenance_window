output "maintenance_window_task_id" {
  description = "Maintenance Window Task ID"
  value = element(
    coalescelist(
      aws_ssm_maintenance_window_task.maintenance_window_task_no_logging.*.id,
      aws_ssm_maintenance_window_task.maintenance_window_task_with_logging.*.id,
      [""],
    ),
    0,
  )
}

