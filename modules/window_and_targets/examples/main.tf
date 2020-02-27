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

data "aws_region" "current_region" {
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
  source              = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_autorecovery.git?ref=v0.0.5"
  ec2_os              = "centos7"
  instance_count      = "1"
  subnets             = [element(module.vpc.private_subnets, 0)]
  security_group_list = [module.vpc.default_sg]
  image_id            = data.aws_ami.amazon_centos_7.image_id
  instance_type       = "t2.micro"
  resource_name       = "MAINT_WINDOW_TEST-${random_string.r_string.result}"
}

module "s3_logging" {
  source            = "git@github.com:rackspace-infrastructure-automation/aws-terraform-s3//?ref=v0.0.3"
  bucket_name       = "s3logging-${lower(random_string.r_string.result)}"
  bucket_acl        = "private"
  bucket_logging    = false
  environment       = "Development"
  lifecycle_enabled = false
  versioning        = false
}

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
  target_values              = [module.ar_test.ar_instance_id_list]
}

