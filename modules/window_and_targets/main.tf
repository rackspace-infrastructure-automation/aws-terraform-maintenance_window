resource "aws_ssm_maintenance_window" "maintenance_window" {
  cutoff                     = "${var.cutoff}"
  duration                   = "${var.duration}"
  name                       = "${var.name}"
  schedule                   = "${var.schedule}"
  allow_unassociated_targets = "${var.allow_unassociated_targets}"
}

resource "aws_ssm_maintenance_window_target" "maintenance_window_target" {
  resource_type     = "${var.resource_type}"
  owner_information = "${var.owner_information}"

  targets {
    key    = "${var.target_key}"
    values = ["${var.target_values}"]
  }

  window_id = "${aws_ssm_maintenance_window.maintenance_window.id}"
}
