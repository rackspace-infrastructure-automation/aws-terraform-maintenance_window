variable "enable_s3_logging" {
  description = "Enable logging to s3 for the maintenance window task. true or false"
  default     = false
  type        = "string"
}

variable "max_concurrency" {
  description = "The maximum number of targets that you can run this task for, in parallel."
  default     = 5
  type        = "string"
}

variable "max_errors" {
  description = "The maximum number of errors allowed before this task stops being scheduled. Minimum length of 1. Maximum length of 7"
  default     = 1
  type        = "string"
}

variable "priority" {
  description = "The priority of the task in the Maintenance Window. The lower the number, the higher the priority. Tasks that have the same priority are scheduled in parallel."
  default     = 0
  type        = "string"
}

variable "service_role_arn" {
  description = "The ARN of the role that's used when the task is executed."
  default     = ""
  type        = "string"
}

variable "s3_bucket_name" {
  description = "Logging S3 Bucket Name"
  default     = ""
  type        = "string"
}

variable "s3_bucket_prefix" {
  description = "Logging S3 Bucket prefix."
  default     = ""
  type        = "string"
}

variable "s3_region" {
  description = "Logging S3 Bucket region"
  default     = ""
  type        = "string"
}

variable "task_parameters" {
  description = "The parameters to pass to the task when it's executed."
  default     = []
  type        = "list"
}

variable "target_key" {
  description = "The Maintenance Window Target ID from the maintenance window target template or InstanceIds"
  default     = ""
  type        = "string"
}

variable "target_values" {
  description = "Comma delimited list of Physical Maintenance Window Target IDs or Instance IDs."
  default     = []
  type        = "list"
}

variable "task_arn" {
  description = "The ARN or Document resource that the task uses during execution. https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ssm-maintenancewindowtask.html#cfn-ssm-maintenancewindowtask-taskarn"
  type        = "string"
}

variable "task_type" {
  description = "The type of task. Only RUN_COMMAND is supported by terraform at this point"
  default     = "RUN_COMMAND"
  type        = "string"
}

variable "window_id" {
  description = "The ID of the Maintenance Window where the task is registered. Format mw-xxxxxxxxxxxx"
  default     = ""
  type        = "string"
}
