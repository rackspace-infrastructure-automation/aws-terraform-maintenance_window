# aws-terraform-maintenance\_window/modules/window\_and\_targets

This submodule creates a Maintenance Window and the targets

## Basic Usage

```
module "maint_window_target" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/window_and_targets?ref=v0.12.0"

  allow_unassociated_targets = false
  cutoff                     = 0
  duration                   = 1
  name                       = "Maintenance-Window"
  owner_information          = "Maintenance Window Task"
  resource_type              = "INSTANCE"
  schedule                   = "cron(15 10 ? * MON *)"
  target_key                 = "InstanceIds"
  target_values              = [module.ar_test.ar_instance_id_list]
}
```

Full working references are available at [examples](examples)

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allow\_unassociated\_targets | Enables a Maintenance Window task to execute on managed instances, even if you haven't registered those instances as targets. If this is enabled, then you must specify the unregistered instances (by instance ID) when you register a task with the Maintenance Window. | `string` | `false` | no |
| cutoff | The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution. | `string` | `0` | no |
| duration | The schedule of the Maintenance Window in the form of a cron or rate expression. | `string` | `1` | no |
| name | The name of the Maintenance Window. Must contain only letters, numbers, periods (.), underscores (\_), backslashes (\), and dashes (-) | `string` | `"Maintenance-Window"` | no |
| owner\_information | A user-provided value to include in any events in CloudWatch Events that are raised while running tasks for these targets in this Maintenance Window. | `string` | `"Maintenance Window Task"` | no |
| resource\_type | The type of target that's being registered with the Maintenance Window. Currently, "INSTANCE" is the only supported resource type. | `string` | `"INSTANCE"` | no |
| schedule | The schedule of the Maintenance Window in the form of a cron or rate expression. https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html | `string` | n/a | yes |
| target\_key | The Maintenance Window Target ID from the maintenance window target template or InstanceIds | `string` | n/a | yes |
| target\_values | List of Physical Maintenance Window Target IDs or Instance IDs. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| maintenance\_window\_id | Maintenance Window ID |
| maintenance\_window\_target\_id | Maintenance Window Target ID |

