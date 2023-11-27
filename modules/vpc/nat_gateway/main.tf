# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count = var.create_nat ? 1 : 0
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.elastic_ip_name
  }
}

### NAT Gateway
resource "aws_nat_gateway" "nat" {
  count = var.create_nat ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.nat_gateway_name
  }
}
