provider "aws" {
  region = var.region
}


terraform {
required_version = "0.13.5"
  backend "s3" {
    bucket = "solvejobs-tfstates"
    key = "data"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      version = "3.21.0"
      source = "hashicorp/aws"
    }
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

output "external_subnets" {
  value = module.vpc.external_subnets
}

output "vpc_id" {
  value = module.vpc.id
}

output "internal_subnets" {
  value = module.vpc.internal_subnets
}

output "subnets1" {
  value = element(module.vpc.external_subnets,0)
}
/*
output "bastion_sg" {
value = module.ec2_bastion.sg
}
module "alb" {
  enable_https_listener = true
  ssl_cert_arn = "arn:aws:acm:us-east-1:971643847977:certificate/b34dcbaa-d812-4c04-bfa0-b9e478cd167d"
  source = "../modules/alb/"
  environment       = "staging"
  alb_name          = "staging-solvejobs"
  vpc_id            = module.vpc.id
  region            = "us-east-1"
  public_subnet_ids = module.vpc.external_subnets
  enable_access_log = "true"
  target_type       = "instance"
  health_check_path  = "/v1/enums"
  target_group_protocol = "HTTPS"
  target_group_port  = "8881"
  health_check_protocol  = "HTTPS"
  health_check_port  = "8881"
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
  aws_ami           = "ami-0f1b45cb0dcba4c1b"
  iam_instance_profile_id = "solvejobs-webapp"
  private_subnet_ids       = module.vpc.internal_subnets
  target_groups = [module.alb.default_alb_target_group]
  health_check_path = "/test"
  key_name = "terraform"
  bastion_sg = module.ec2_bastion.sg
  depends_on  = [module.alb]
}

*/
module "ec2_bastion" {
  source = "../modules/ec2_bastion/"

  enabled = true

  ami           = "ami-00ddb0e5626798373" 
  instance_type = "t3.nano"
  environment = "staging"
  name       = "bastion"
  namespace  = "staging"
  stage      = "staging"
  subnets                 = [element(module.vpc.external_subnets,0)]
  ssh_user                = "lokesh"
  key_name                = "terraform"
  vpc_id = module.vpc.id
}
/*


##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

#####
# DB
#####
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb-postgres"

  engine            = "postgres"
  engine_version    = "11.6"
  instance_class    = "db.t2.micro"
  allocated_storage = 10
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "solvejobs_production"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "demouser"

  password = "YourPwdShouldBeLongAndSecure123"
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = module.vpc.internal_subnets

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "staging-solvejobs"

  # Database Deletion Protection
  deletion_protection = false
}

resource "aws_security_group" "rds_sg" {
  name        = "staging_solvejobs_rds_sg"
  description = "Allow RDS inbound traffic"
  vpc_id      = module.vpc.id

  ingress {
    description = "RDS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.30.96.0/20","172.30.128.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "staging_solvejobs_rds_sg"
  }
}

*/
