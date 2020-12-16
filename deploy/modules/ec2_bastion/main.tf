resource "aws_iam_instance_profile" "default" {
  count = var.enabled ? 1 : 0
  name  = "${var.environment}-bastion"
  role  = aws_iam_role.default[0].name
}

resource "aws_iam_role" "default" {
  count = var.enabled ? 1 : 0
  name  = "${var.environment}-bastion-role"
  path  = "/"

  assume_role_policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_security_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = "${var.environment}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Bastion security group (only SSH inbound access is allowed)"

  tags = {
	environment = var.environment
        type        = "bastion"
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    description = "allow ssh"

    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = var.ingress_security_groups
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    user_data       = join("\n", var.user_data)
    welcome_message = var.stage
    ssh_user        = var.ssh_user
  }
}

resource "aws_instance" "default" {
  count         = var.enabled ? 1 : 0
  ami           = var.ami
  instance_type = var.instance_type

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = compact(concat(aws_security_group.default.*.id, var.security_groups))

  iam_instance_profile        = aws_iam_instance_profile.default[0].name
  associate_public_ip_address = var.associate_public_ip_address

  key_name = var.key_name

  subnet_id = var.subnets[0]

  tags = {
        Environment = var.environment
        Type        = "bastion"
        Name        = "${var.environment}-bastion"
}

  metadata_options {
    http_endpoint               = (var.metadata_http_endpoint_enabled) ? "enabled" : "disabled"
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = (var.metadata_http_tokens_required) ? "required" : "optional"
  }

  root_block_device {
    encrypted   = var.root_block_device_encrypted
    volume_size = var.root_block_device_volume_size
  }
}
