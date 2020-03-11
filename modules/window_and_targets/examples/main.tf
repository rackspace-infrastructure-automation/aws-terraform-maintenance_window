provider "aws" {
  region = "us-west-2"
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

data "aws_ami" "amazon_centos_7" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

module "ar_test" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery.git?ref=v0.12.4"

  ec2_os          = "centos7"
  image_id        = data.aws_ami.amazon_centos_7.image_id
  instance_count  = 1
  instance_type   = "t2.micro"
  name            = "MAINT_WINDOW_TEST-${random_string.r_string.result}"
  security_groups = [module.vpc.default_sg]
  subnets         = [element(module.vpc.private_subnets, 0)]
}

module "s3_logging" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3//?ref=v0.12.0"

  bucket_acl        = "private"
  bucket_logging    = false
  environment       = "Development"
  lifecycle_enabled = false
  name              = "s3logging-${lower(random_string.r_string.result)}"
  versioning        = false
}

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

module "maintenance_window_task_1" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/task?ref=v0.12.0"

  enable_s3_logging = true
  max_concurrency   = 5
  max_errors        = 1
  priority          = 1
  s3_bucket_name    = module.s3_logging.bucket_id
  s3_region         = module.s3_logging.bucket_region
  service_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  target_key        = "WindowTargetIds"
  target_values     = [module.maint_window_target.maintenance_window_target_id]
  task_arn          = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
  task_type         = "RUN_COMMAND"
  window_id         = module.maint_window_target.maintenance_window_id

  task_invocation_run_comand_parameters = [
    {
      name   = "PreferredTimeClient"
      values = ["chrony"]
    },
  ]
}

module "maintenance_window_task_2" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-maintenance_window//modules/task?ref=v0.12.0"

  enable_s3_logging = false
  max_concurrency   = 5
  max_errors        = 1
  priority          = 0
  service_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  target_key        = "WindowTargetIds"
  target_values     = [module.maint_window_target.maintenance_window_target_id]
  task_arn          = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-Install_Package"
  task_type         = "RUN_COMMAND"
  window_id         = module.maint_window_target.maintenance_window_id

  task_invocation_run_comand_parameters = [
    {
      name   = "Packages"
      values = ["bind bind-utils"]
    },
  ]
}
