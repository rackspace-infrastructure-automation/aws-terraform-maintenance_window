variable "allow_unassociated_targets" {
  description = "Enables a Maintenance Window task to execute on managed instances, even if you haven't registered those instances as targets. If this is enabled, then you must specify the unregistered instances (by instance ID) when you register a task with the Maintenance Window."
  default     = false
  type        = string
}

variable "cutoff" {
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution."
  default     = 0
  type        = string
}

variable "duration" {
  description = "The schedule of the Maintenance Window in the form of a cron or rate expression."
  default     = 1
  type        = string
}

variable "name" {
  description = "The name of the Maintenance Window. Must contain only letters, numbers, periods (.), underscores (_), backslashes (\\), and dashes (-)"
  default     = "Maintenance-Window"
  type        = string
}

variable "owner_information" {
  description = "A user-provided value to include in any events in CloudWatch Events that are raised while running tasks for these targets in this Maintenance Window."
  default     = "Maintenance Window Task"
  type        = string
}

variable "resource_type" {
  description = "The type of target that's being registered with the Maintenance Window. Currently, \"INSTANCE\" is the only supported resource type."
  default     = "INSTANCE"
  type        = string
}

variable "schedule" {
  description = "The schedule of the Maintenance Window in the form of a cron or rate expression. https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html"
  type        = string
}

variable "target_key" {
  description = "The Maintenance Window Target ID from the maintenance window target template or InstanceIds"
  type        = string
}

variable "target_values" {
  description = "List of Physical Maintenance Window Target IDs or Instance IDs."
  type        = list(string)
}

