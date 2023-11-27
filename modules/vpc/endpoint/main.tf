resource "aws_vpc_endpoint" "gateway" {
  count             = var.create_gateway ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name = var.endpoint_name
  }
}

resource "aws_vpc_endpoint" "interface" {
  count             = var.create_interface ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids

  tags = {
    Name = var.endpoint_name
  }
}
