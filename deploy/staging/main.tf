provider "aws" {
region = var.region
}


terraform {
  backend "s3" {
    bucket = "solvejobs-tfstates"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc" {
source = "../modules/vpc/"
vpc_cidr = "172.30.0.0/16"
environment  = var.env
vpc_name = var.vpc_name
external_subnets = [
{name = "pubsub-1", cidr = "172.30.0.0/20", az = "us-east-1a"},
{name = "pubsub-2", cidr = "172.30.32.0/20", az = "us-east-1b"},
]

internal_subnets = [
{name = "privsub-1", cidr = "172.30.96.0/20", az = "us-east-1a"},
{name = "privsub-2", cidr = "172.30.128.0/20", az = "us-east-1b"},
]
}

output "subnets" {
value = module.vpc.external_subnets
}

module "alb" {
  source = "../modules/alb/"
  environment       = "staging"
  alb_name          = "staging-solvejobs"
  vpc_id            = module.vpc.id
  region            = "us-east-1"
  public_subnet_ids = module.vpc.external_subnets
  enable_access_log = "true"
  target_type       = "instance"

}

output "tg" {
value = module.alb.default_alb_target_group
}

module "asg" {
  source = "../modules/asg_instances/"
  environment = "staging"
  max_size =  2
  min_size =  1
  cloudwatch_prefix = "staging-solvejobs"
  instance_group    = "solvejobs"
  vpc_id            = module.vpc.id
  aws_ami           = "ami-00ddb0e5626798373"
  iam_instance_profile_id = "terraform-ec2"
  private_subnet_ids       = module.vpc.external_subnets
  target_groups = [module.alb.default_alb_target_group]
  key_name = "terraform"
  }
