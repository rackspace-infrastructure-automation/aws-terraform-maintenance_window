resource "aws_ssm_maintenance_window_task" "maintenance_window_task_with_logging" {
  count            = "${var.enable_s3_logging ? 1 : 0}"
  name             = "${var.resource_name}"
  description      = "${var.maintenance_window_description}"
  max_errors       = "${var.max_errors}"
  service_role_arn = "${var.service_role_arn}"
  priority         = "${var.priority}"
  task_type        = "${var.task_type}"
  task_arn         = "${var.task_arn}"
  window_id        = "${var.window_id}"
  max_concurrency  = "${var.max_concurrency}"

  task_parameters = ["${var.task_parameters}"]

  targets {
    key    = "${var.target_key}"
    values = ["${var.target_values}"]
  }

  logging_info {
    s3_bucket_name   = "${var.s3_bucket_name}"
    s3_region        = "${var.s3_region}"
    s3_bucket_prefix = "${var.s3_bucket_prefix}"
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_no_logging" {
  count            = "${var.enable_s3_logging ? 0 : 1}"
  name             = "${var.resource_name}"
  description      = "${var.maintenance_window_description}"
  max_errors       = "${var.max_errors}"
  service_role_arn = "${var.service_role_arn}"
  priority         = "${var.priority}"
  task_type        = "${var.task_type}"
  task_arn         = "${var.task_arn}"
  window_id        = "${var.window_id}"
  max_concurrency  = "${var.max_concurrency}"

  task_parameters = ["${var.task_parameters}"]

  targets {
    key    = "${var.target_key}"
    values = ["${var.target_values}"]
  }
}
