output "vpc_id" {
  value = aws_vpc.default.id
}

output "private_subnet" {
  value = aws_subnet.private
}

output "default_sg" {
  value = aws_security_group.default
}