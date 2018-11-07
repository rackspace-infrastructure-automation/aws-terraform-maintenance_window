# aws-terraform-maintenance_window

This repository contains several terraform submodules that can be used to deploy a maintenance window with targets and maintenance window tasks. This repo was divided up into two submodules to allow the user to assign multiple maintenance window tasks to a single maintenance window and single set of targets.

## Module Listing
- [window_and_targets](./modules/window_and_targets/) - A terraform module that can create a maintance window and maintenance window target.
- [task](./modules/task) - A terraform module that can deploy a `RUN_COMMAND` maintenance window task. NOTE: Terraform currently only supports running Command documents for maintenance window tasks. Lambdas, Step Functions and SSM Automation in maintenance window tasks are currently not supported by Terraform at the time of this writing.
