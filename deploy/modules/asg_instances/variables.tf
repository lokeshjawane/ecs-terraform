variable "environment" {
  description = "The name of the environment"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}


variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "aws_ami" {
  description = "The AWS ami id to use"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type to use"
}

variable "max_size" {
  default     = 1
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  default     = 1
  description = "Minimum size of the nodes in the cluster"
}

#For more explenation see http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html
variable "desired_capacity" {
  default     = 1
  description = "The desired capacity of the cluster"
}

variable "iam_instance_profile_id" {
  description = "The id of the instance profile that should be used for the instances"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "The list of private subnets to place the instances in"
}

variable "target_groups" {
  type        = "list"
  default     = []
  description = "The target groups list"
}

variable "load_balancers" {
  type        = "list"
  default     = []
  description = "The load balancers to couple to the instances. Only used when NOT using ALB"
}

variable "key_name" {
  description = "SSH key name to be used"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "root_disk_size" {
  default = 20
  description = "root disk size"
}

variable "root_disk_type" {
  default = "gp2"
  description = "root disk type"
}

variable "termination_policies" {
  default = ["OldestInstance"]
  type        = "list"
  description = "termination polici for ASG"
}

variable "health_check_port" {
   default = 80
}
