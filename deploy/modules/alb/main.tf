  # Default ALB implementation that can be used connect ECS instances to it

resource "aws_alb_target_group" "default" {
  name                 = "${var.alb_name}-default"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "${var.target_type}"
  deregistration_delay = "${var.deregistration_delay}"
  health_check {
    path     = "${var.health_check_path}"
    protocol = "HTTP"
    port     = 80
    matcher  = "200,302"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb" "alb" {
  name            = "${var.alb_name}"
  internal	  =  "${var.internal_type}"
  subnets         = "${var.public_subnet_ids}"
  security_groups = ["${aws_security_group.alb.id}"]
  enable_deletion_protection = "${var.enable_deletion_protection}"
  access_logs {
	bucket = "${var.alb_name}-access-log"
        prefix = "elb-logs"
	enabled = true
  }

  tags = {
    Environment = var.environment
  }
  depends_on=["aws_s3_bucket.bucket"]
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "https_listener" {
  count  = "${var.enable_https_listener ? 1 : 0}" 
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.alb_name}_alb"
  vpc_id = "${var.vpc_id}"

  tags =  {
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "https_from_anywhere" {
  count  = "${var.enable_https_listener ? 1 : 0}" 
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_s3_bucket" "bucket" {
  count  = var.enable_access_log == "true" ? 1 : 0
  bucket = "${var.alb_name}-access-log"
  lifecycle_rule {
    id      = "access_log"
    prefix  = "*"
    enabled = true

    noncurrent_version_expiration {
      days = 120
    }
  }
policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy1472815681915",
    "Statement": [
        {
            "Sid": "Stmt1472815679672",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.region_id[var.region]}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.alb_name}-access-log/elb-logs/*"
        }
    ]
}
POLICY
  tags = {
    Name        = "Environment"
    Environment = var.environment
  }
}
