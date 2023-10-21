###################
#       ELB       #
###################

output "target_group_arn" {
  value = aws_alb_target_group.default.arn
}

output "dns_name" {
  value = aws_lb.default.dns_name
}

output "zone_id" {
  value = aws_lb.default.zone_id
}