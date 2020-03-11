/*
 * # aws-terraform-maintenance_window/modules/task
 *
 * This submodule creates an Maintenance Window Task
 *
 * ## Basic Usage
 *
 * ```
 * module "maintenance_window_task_1" {
 *   source           = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/task?ref=v0.0.1"
 *   max_errors       = "1"
 *   service_role_arn = "arn:aws:iam::794790922771:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
 *   priority         = "0"
 *   task_type        = "RUN_COMMAND"
 *   task_arn         = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
 *   window_id        = "${module.maint_window_target.maintenance_window_id}"
 *   max_concurrency  = "5"
 *   target_key       = "WindowTargetIds"
 *   target_values    = ["${module.maint_window_target.maintenance_window_target_id}"]
 *
 *   task_parameters = {
 *     name   = "PreferredTimeClient"
 *     values = ["chrony"]
 *   }
 *
 *   enable_s3_logging = true
 *   s3_bucket_name    = "${module.s3_logging.bucket_id}"
 *   s3_region         = "${module.s3_logging.bucket_region}"
 * }
 * ```
 *
 * Full working references are available at [examples](examples)
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.1.0"
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_with_logging" {
  count            = var.enable_s3_logging ? 1 : 0
  name             = var.name
  description      = var.maintenance_window_description
  max_errors       = var.max_errors
  service_role_arn = var.service_role_arn
  priority         = var.priority > 0 ? var.priority : null
  task_type        = var.task_type
  task_arn         = var.task_arn
  window_id        = var.window_id
  max_concurrency  = var.max_concurrency

  task_invocation_parameters {
    run_command_parameters {
      output_s3_bucket     = var.s3_bucket_name
      output_s3_key_prefix = var.s3_bucket_prefix
      service_role_arn     = var.service_role_arn

      dynamic "parameter" {
        for_each = var.task_invocation_run_comand_parameters

        content {
          name   = parameter.value.name
          values = parameter.value.values
        }
      }
    }
  }

  targets {
    key    = var.target_key
    values = var.target_values
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_no_logging" {
  count            = var.enable_s3_logging ? 0 : 1
  name             = var.name
  description      = var.maintenance_window_description
  max_errors       = var.max_errors
  service_role_arn = var.service_role_arn
  priority         = var.priority
  task_type        = var.task_type
  task_arn         = var.task_arn
  window_id        = var.window_id
  max_concurrency  = var.max_concurrency

  task_invocation_parameters {
    run_command_parameters {
      service_role_arn = var.service_role_arn

      dynamic "parameter" {
        for_each = var.task_invocation_run_comand_parameters

        content {
          name   = parameter.value.name
          values = parameter.value.values
        }
      }
    }
  }

  targets {
    key    = var.target_key
    values = var.target_values
  }
}
