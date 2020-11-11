output "alb_security_group_id" {
  value = "${aws_security_group.alb.id}"
}

output "default_alb_target_group" {
  value = "${aws_alb_target_group.default.id}"
}

output "default_alb_asg" {
  value = "${aws_alb.alb.id}"
}

output "http_listener_arn" {
	value = "${aws_alb_listener.https.arn}"
}

output "https_listener_arn" {
	value = "${var.enable_https_listener ? aws_alb_listener.https.arn : "not_listener_arn"}"
}

output "alb_arn" {
	value = "${aws_alb.alb.arn}"
}
