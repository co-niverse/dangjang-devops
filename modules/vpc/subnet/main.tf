# Create subnets
resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = var.vpc_id
  cidr_block              = "10.${var.vpc_cidr_numeral}.${each.value.numeral}.0/24"
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = each.key
  }
}

# Create route table
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.route_table_name
  }
}

# Create route
resource "aws_route" "internet_gateway" {
  count                  = var.enable_igw_destination ? 1 : 0
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = var.destination_cidr_block_igw
  gateway_id             = var.igw_id
}

resource "aws_route" "nat_gateway" {
  count                  = var.enable_nat_destination ? 1 : 0
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = var.destination_cidr_block_nat
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route" "vpc_endpoint" {
  count                  = var.enable_vpc_endpoint_destination ? 1 : 0
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = var.destination_cidr_block_vpc_endpoint
  vpc_endpoint_id        = var.vpc_endpoint_id
}

resource "aws_route" "network_interface" {
  count                  = var.enable_network_interface_destination ? 1 : 0
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = var.destination_cidr_block_network_interface
  network_interface_id   = var.network_interface_id
}

# Associate route table to subnets
resource "aws_route_table_association" "route_table_association" {
  for_each       = aws_subnet.subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}
