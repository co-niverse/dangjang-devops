output "id" {
  value = var.create_nat ? aws_nat_gateway.nat[0].id : null
}
