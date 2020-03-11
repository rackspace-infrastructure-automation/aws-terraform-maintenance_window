provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

resource "random_string" "r_string" {
  length  = 6
  lower   = false
  number  = false
  special = false
  upper   = true
}

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=v0.12.1"

  name = "MAINT-WINDOW-TEST-${random_string.r_string.result}"
}

data "aws_region" "current_region" {
}

data "aws_caller_identity" "current_account" {
}

module "ar_test" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery.git?ref=v0.12.4"

  ec2_os          = "centos7"
  instance_count  = "1"
  instance_type   = "t2.micro"
  name            = "MAINT_WINDOW_TEST-${random_string.r_string.result}"
  security_groups = [module.vpc.default_sg]
  subnets         = [element(module.vpc.private_subnets, 0)]
}

module "s3_logging" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3?ref=v0.12.0"

  bucket_acl           = "private"
  bucket_logging       = false
  environment          = "Development"
  force_destroy_bucket = true
  lifecycle_enabled    = false
  name                 = "s3logging-${lower(random_string.r_string.result)}"
  versioning           = false
}

module "maint_window_target" {
  source = "../../module/modules/window_and_targets"

  allow_unassociated_targets = false
  cutoff                     = "0"
  duration                   = "1"
  name                       = "Maintenance-Window"
  owner_information          = "Maintenance Window Task"
  resource_type              = "INSTANCE"
  schedule                   = "cron(15 10 ? * MON *)"
  target_key                 = "InstanceIds"
  target_values              = module.ar_test.ar_instance_id_list
}

module "maintenance_window_task_1" {
  source = "../../module/modules/task"

  enable_s3_logging              = true
  maintenance_window_description = "Test Maintenance Window 1"
  max_concurrency                = "5"
  max_errors                     = "1"
  name                           = "Test_Maintenance_Window_1_${random_string.r_string.result}"
  priority                       = 1
  s3_bucket_name                 = module.s3_logging.bucket_id
  s3_region                      = module.s3_logging.bucket_region
  service_role_arn               = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  target_key                     = "WindowTargetIds"
  target_values                  = [module.maint_window_target.maintenance_window_target_id]
  task_arn                       = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
  task_type                      = "RUN_COMMAND"
  window_id                      = module.maint_window_target.maintenance_window_id

  task_invocation_run_comand_parameters = [
    {
      name   = "PreferredTimeClient"
      values = ["chrony"]
    },
  ]


}

module "maintenance_window_task_2" {
  source = "../../module/modules/task"

  enable_s3_logging              = false
  maintenance_window_description = "Test Maintenance Window 2"
  max_concurrency                = "5"
  max_errors                     = "1"
  name                           = "Test_Maintenance_Window_2_${random_string.r_string.result}"
  priority                       = 2
  service_role_arn               = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  target_key                     = "WindowTargetIds"
  target_values                  = [module.maint_window_target.maintenance_window_target_id]
  task_arn                       = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-Install_Package"
  task_type                      = "RUN_COMMAND"
  window_id                      = module.maint_window_target.maintenance_window_id

  task_invocation_run_comand_parameters = [
    {
      name   = "Packages"
      values = ["bind bind-utils"]
    },
  ]
}
