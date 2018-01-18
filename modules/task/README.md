# aws-terraform-maintenance_window/modules/task

This submodule creates an Maintenance Window Task

## Basic Usage

```
module "maintenance_window_task_1" {
 source           = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/task?ref=v0.0.1"
 max_errors       = "1"
 service_role_arn = "arn:aws:iam::794790922771:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
 priority         = "0"
 task_type        = "RUN_COMMAND"
 task_arn         = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
 window_id        = "${module.maint_window_target.maintenance_window_id}"
 max_concurrency  = "5"
 target_key       = "WindowTargetIds"
 target_values    = ["${module.maint_window_target.maintenance_window_target_id}"]

 task_parameters = {
   name   = "PreferredTimeClient"
   values = ["chrony"]
 }

 enable_s3_logging = true
 s3_bucket_name    = "${module.s3_logging.bucket_id}"
 s3_region         = "${module.s3_logging.bucket_region}"
}
```

Full working references are available at [examples](examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable\_s3\_logging | Enable logging to s3 for the maintenance window task. true or false | string | `"false"` | no |
| maintenance\_window\_description | Description for maintenance window | string | n/a | yes |
| max\_concurrency | The maximum number of targets that you can run this task for, in parallel. | string | `"5"` | no |
| max\_errors | The maximum number of errors allowed before this task stops being scheduled. Minimum length of 1. Maximum length of 7 | string | `"1"` | no |
| priority | The priority of the task in the Maintenance Window. The lower the number, the higher the priority. Tasks that have the same priority are scheduled in parallel. | string | `"0"` | no |
| resource\_name | Name to be used for the resources to be provisioned | string | n/a | yes |
| s3\_bucket\_name | Logging S3 Bucket Name | string | `""` | no |
| s3\_bucket\_prefix | Logging S3 Bucket prefix. | string | `""` | no |
| s3\_region | Logging S3 Bucket region | string | `""` | no |
| service\_role\_arn | The ARN of the role that's used when the task is executed. | string | `""` | no |
| target\_key | The Maintenance Window Target ID from the maintenance window target template or InstanceIds | string | n/a | yes |
| target\_values | Comma delimited list of Physical Maintenance Window Target IDs or Instance IDs. | list | n/a | yes |
| task\_arn | The ARN or Document resource that the task uses during execution. https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ssm-maintenancewindowtask.html#cfn-ssm-maintenancewindowtask-taskarn | string | n/a | yes |
| task\_parameters | The parameters to pass to the task when it's executed. | list | `<list>` | no |
| task\_type | The type of task. Only RUN_COMMAND is supported by terraform at this point | string | `"RUN_COMMAND"` | no |
| window\_id | The ID of the Maintenance Window where the task is registered. Format mw-xxxxxxxxxxxx | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| maintenance\_window\_task\_id | Maintenance Window Task ID |

