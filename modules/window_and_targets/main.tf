/*
 * # aws-terraform-maintenance_window/modules/window_and_targets
 *
 * This submodule creates a Maintenance Window and the targets
 *
 * ## Basic Usage
 *
 * ```
 * module "maint_window_target" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/window_and_targets?ref=v0.12.0"
 *
 *   allow_unassociated_targets = false
 *   cutoff                     = 0
 *   duration                   = 1
 *   name                       = "Maintenance-Window"
 *   owner_information          = "Maintenance Window Task"
 *   resource_type              = "INSTANCE"
 *   schedule                   = "cron(15 10 ? * MON *)"
 *   target_key                 = "InstanceIds"
 *   target_values              = [module.ar_test.ar_instance_id_list]
 * }
 * ```
 *
 * Full working references are available at [examples](examples)
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.7.0"
  }
}

resource "aws_ssm_maintenance_window" "maintenance_window" {
  allow_unassociated_targets = var.allow_unassociated_targets
  cutoff                     = var.cutoff
  duration                   = var.duration
  name                       = var.name
  schedule                   = var.schedule
}

resource "aws_ssm_maintenance_window_target" "maintenance_window_target" {
  owner_information = var.owner_information
  resource_type     = var.resource_type
  window_id         = aws_ssm_maintenance_window.maintenance_window.id

  targets {
    key    = var.target_key
    values = var.target_values
  }
}
