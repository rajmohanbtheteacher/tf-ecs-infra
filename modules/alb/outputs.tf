output "target_group_arn_app1" {
  value = aws_lb_target_group.app.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.this.arn
}
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}