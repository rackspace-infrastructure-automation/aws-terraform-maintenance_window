/*
 * # aws-terraform-maintenance_window/modules/task
 *
 * This submodule creates an Maintenance Window Task
 *
 * ## Basic Usage
 *
 * ```
 * module "maintenance_window_task_1" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/task?ref=v0.12.0"
 *
 *   enable_s3_logging = true
 *   max_concurrency   = 5
 *   max_errors        = 1
 *   priority          = 1
 *   s3_bucket_name    = module.s3_logging.bucket_id
 *   s3_region         = module.s3_logging.bucket_region
 *   service_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
 *   target_key        = "WindowTargetIds"
 *   target_values     = [module.maint_window_target.maintenance_window_target_id]
 *   task_arn          = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
 *   task_type         = "RUN_COMMAND"
 *   window_id         = module.maint_window_target.maintenance_window_id
 *
 *   task_invocation_run_command_parameters = [
 *     {
 *       name   = "PreferredTimeClient"
 *       values = ["chrony"]
 *     },
 *   ]
 * }
 * ```
 *
 * Full working references are available at [examples](examples)
 *
 * ## Terraform 0.12 upgrade
 * Several changes were required while adding terraform 0.12 compatibility.  The following changes should
 * made when upgrading from a previous release to version 0.12.0 or higher.
 *
 * ### Module variables
 *
 * The following module variables were updated to better meet current Rackspace style guides:
 *
 * - `resource_name` -> `name`
 * - `task_parameters` -> `task_invocation_run_comand_parameters`
 *
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.7.0"
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_with_logging" {
  count = var.enable_s3_logging ? 1 : 0

  description      = var.maintenance_window_description
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors
  name             = var.name
  priority         = var.priority > 0 ? var.priority : null
  service_role_arn = var.service_role_arn
  task_arn         = var.task_arn
  task_type        = var.task_type
  window_id        = var.window_id

  targets {
    key    = var.target_key
    values = var.target_values
  }

  task_invocation_parameters {
    run_command_parameters {
      output_s3_bucket     = var.s3_bucket_name
      output_s3_key_prefix = var.s3_bucket_prefix
      service_role_arn     = var.service_role_arn

      dynamic "parameter" {
        for_each = var.task_invocation_run_command_parameters

        content {
          name   = parameter.value.name
          values = parameter.value.values
        }
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_no_logging" {
  count = var.enable_s3_logging ? 0 : 1

  description      = var.maintenance_window_description
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors
  name             = var.name
  priority         = var.priority
  service_role_arn = var.service_role_arn
  task_arn         = var.task_arn
  task_type        = var.task_type
  window_id        = var.window_id

  targets {
    key    = var.target_key
    values = var.target_values
  }

  task_invocation_parameters {
    run_command_parameters {
      service_role_arn = var.service_role_arn

      dynamic "parameter" {
        for_each = var.task_invocation_run_command_parameters

        content {
          name   = parameter.value.name
          values = parameter.value.values
        }
      }
    }
  }
}
