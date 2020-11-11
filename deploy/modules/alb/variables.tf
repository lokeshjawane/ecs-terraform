variable "alb_name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

variable "environment" {
  description = "The name of the environment"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "enable_https_listener" {
  default = false
  description = "Set to true if need to create HTTPs listener"
}

variable "ssl_cert_arn" {
  default = ""
  description = "Mandatory to set ACM ssl arn, if you're creating the HTTPS listener"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cird block that is allowd to acces the LoadBalancer"
}

variable "target_type" {
  default     = "instance"
  description = "target type for alb target group"
}

variable "internal_type" {
  default     = false 
  description = "ALB type"
}

variable "enable_access_log" {
  default     = true
  description = "enable access log for LB"
}

variable "enable_deletion_protection" {
  default     = false
  description = "enable access log for LB"
}

variable "region_id" {
  type = "map"
  default = {
    us-east-1 = "127311923021"
    us-west-1 = "027434742980"
    us-west-2 = "797873946194"
    eu-west-1 = "156460612806"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ap-south-1 = "718504428378"
    us-east-2 = "033677994240"
    sa-east-1 = "507241528517"
    cn-north-1 = "638102146993"
    eu-central-1 = "054676820928"
}
}

variable "region" {
  default = "ap-southeast-1"
}

#variable "aws_account_id" {
#}
