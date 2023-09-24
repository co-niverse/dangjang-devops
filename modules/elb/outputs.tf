###################
#       ELB       #
###################

output "elb_target_group_arn" {
  value = aws_alb_target_group.default.arn
}

output "elb_dns_name" {
  value = aws_lb.default.dns_name
}

output "elb_zone_id" {
  value = aws_lb.default.zone_id
}