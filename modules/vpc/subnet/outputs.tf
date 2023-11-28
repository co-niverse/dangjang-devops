output "ids" {
  value = [for s in aws_subnet.subnet : s.id]
}

output "route_table_id" {
  value = aws_route_table.route_table.id
}