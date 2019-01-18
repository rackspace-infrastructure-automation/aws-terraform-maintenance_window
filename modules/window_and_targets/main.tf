/**
* # aws-terraform-maintenance_window/modules/window_and_targets
*
*This submodule creates a Maintenance Window and the targets
*
*## Basic Usage
*
*```
module "maint_window_target" {
*  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/window_and_targets?ref=v0.0.1"
*  cutoff                     = "0"
*  duration                   = "1"
*  name                       = "Maintenance-Window"
*  schedule                   = "cron(15 10 ? * MON *)"
*  allow_unassociated_targets = "False"
*  resource_type              = "INSTANCE"
*  owner_information          = "Maintenance Window Task"
*  target_key                 = "InstanceIds"
*  target_values              = ["${module.ar_test.ar_instance_id_list}"]
*}
*```
*
* Full working references are available at [examples](examples)
*/

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
