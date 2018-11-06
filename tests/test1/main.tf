provider "aws" {
  region = "us-west-2"
}

resource "random_string" "r_string" {
  length  = 6
  upper   = true
  lower   = false
  special = false
  number  = false
}

module "vpc" {
  source   = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=v0.0.6"
  vpc_name = "MAINT-WINDOW-TEST-${random_string.r_string.result}"
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "current_account" {}

data "aws_ami" "amazon_centos_7" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

module "ar_test" {
  source              = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery.git?ref=v0.0.5"
  ec2_os              = "centos7"
  instance_count      = "1"
  subnets             = ["${element(module.vpc.private_subnets, 0)}"]
  security_group_list = ["${module.vpc.default_sg}"]
  image_id            = "${data.aws_ami.amazon_centos_7.image_id}"
  instance_type       = "t2.micro"
  resource_name       = "MAINT_WINDOW_TEST-${random_string.r_string.result}"
}

module "s3_logging" {
  source               = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3?ref=v0.0.4"
  bucket_name          = "s3logging-${lower(random_string.r_string.result)}"
  bucket_acl           = "private"
  bucket_logging       = false
  environment          = "Development"
  lifecycle_enabled    = false
  versioning           = false
  force_destroy_bucket = true
}

module "maint_window_target" {
  source                     = "../../module/modules/window_and_targets"
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

module "maintenance_window_task_1" {
  source           = "../../module/modules/task"
  max_errors       = "1"
  service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  priority         = "0"
  task_type        = "RUN_COMMAND"
  task_arn         = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-ConfigureAWSTimeSync"
  window_id        = "${module.maint_window_target.maintenance_window_id}"
  max_concurrency  = "5"
  target_key       = "WindowTargetIds"
  target_values    = ["${module.maint_window_target.maintenance_window_target_id}"]

  task_parameters = [{
    name   = "PreferredTimeClient"
    values = ["chrony"]
  }]

  enable_s3_logging = true
  s3_bucket_name    = "${module.s3_logging.bucket_id}"
  s3_region         = "${module.s3_logging.bucket_region}"
}

module "maintenance_window_task_2" {
  source           = "../../module/modules/task"
  max_errors       = "1"
  service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  priority         = "0"
  task_type        = "RUN_COMMAND"
  task_arn         = "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-Install_Package"
  window_id        = "${module.maint_window_target.maintenance_window_id}"
  max_concurrency  = "5"
  target_key       = "WindowTargetIds"
  target_values    = ["${module.maint_window_target.maintenance_window_target_id}"]

  task_parameters = [{
    name   = "Packages"
    values = ["bind bind-utils"]
  }]

  enable_s3_logging = false
}

output "maintenance_window_target_id" {
  value = "${module.maint_window_target.maintenance_window_target_id}"
}

output "maintenance_window_id" {
  value = "${module.maint_window_target.maintenance_window_id}"
}

output "maintenance_window_task_1_id" {
  value = "${module.maintenance_window_task_1.maintenance_window_task_id}"
}

output "maintenance_window_task_2_id" {
  value = "${module.maintenance_window_task_2.maintenance_window_task_id}"
}
