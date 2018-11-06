## Basic Usage
```
module "maint_window_target" {
  source                     = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/window_and_targets?ref=v0.0.1"
  cutoff                     = "0"
  duration                   = "1"
  name                       = "Maintenance-Window"
  schedule                   = "cron(15 10 ? * MON *)"
  allow_unassociated_targets = "False"
  resource_type              = "INSTANCE"
  owner_information          = "Maintenance Window Task"
  target_key                 = "InstanceIds"
  target_values              = ["${module.ar_test.ar_instance_id_list}"]
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow_unassociated_targets | Enables a Maintenance Window task to execute on managed instances, even if you haven't registered those instances as targets. If this is enabled, then you must specify the unregistered instances (by instance ID) when you register a task with the Maintenance Window. | string | `false` | no |
| cutoff | The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution. | string | `0` | no |
| duration | The schedule of the Maintenance Window in the form of a cron or rate expression. | string | `1` | no |
| name | The name of the Maintenance Window. Must contain only letters, numbers, periods (.), underscores (_), backslashes (\), and dashes (-) | string | `Maintenance-Window` | no |
| owner_information | A user-provided value to include in any events in CloudWatch Events that are raised while running tasks for these targets in this Maintenance Window. | string | `Maintenance Window Task` | no |
| resource_type | The type of target that's being registered with the Maintenance Window. | string | `INSTANCE` | no |
| schedule | The schedule of the Maintenance Window in the form of a cron or rate expression. https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html | string | - | yes |
| target_key | The Maintenance Window Target ID from the maintenance window target template or InstanceIds | string | - | yes |
| target_values | List of Physical Maintenance Window Target IDs or Instance IDs. | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| maintenance_window_id | Maintenance Window ID |
| maintenance_window_target_id | Maintenance Window Target ID |
