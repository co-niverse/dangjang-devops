output "vpc_id" {
  value = aws_vpc.default.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "default_sg" {
  value = aws_security_group.default.arn
}

output "app_sg" {
  value = aws_security_group.app.arn
}
