output "ecs_instance_security_group_id" {
  value = "${aws_security_group.instance.id}"
}

output "asg_name" {
  value = "${var.environment}-${var.instance_group}"
}

output "target_group_arn" {
	value = ["${aws_lb_target_group.default.*.arn}"]
}

#output "autoscale_group_id" {
#  value = "${aws_autoscaling_group.asg.id}"
#}
