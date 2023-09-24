# VPC
# VPC CIDR will use the B class with 10.x.0.0/16
resource "aws_vpc" "default" {
  cidr_block = "10.${var.cidr_numeral}.0.0/16"
  tags = {
    Name = "vpc-${var.env}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "igw-${var.env}"
  }
}


### NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # public subnet 0번 지정

  tags = {
    Name = "nat-gw-${var.env}"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "nat-gw-eip-${var.env}"
  }
}


### Public Subnets
# Subnet will use cidr with /24 -> The number of available IP is 256
resource "aws_subnet" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true # public IP 자동 할당

  tags = {
    Name = "public-sb${count.index}-${var.env}"
  }
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "public-rt-${var.env}"
  }
}

# Route Table Association for public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


### Private Subnetss
# Subnet will use cidr with /24 -> The number of available IP is 256
resource "aws_subnet" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-sb${count.index}-${var.env}"
  }
}

# Route Table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "private-rt-${var.env}"
  }
}

# Route Table Association for private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


### DB Private Subnets
# Subnet will use cidr with /24 -> The number of available IP is 256
resource "aws_subnet" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_db[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-db-sb${count.index}-${var.env}"
  }
}

# Route Table for DB subnets
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "private-db-rt-${var.env}"
  }
}

# Route Table Association for DB subnets
resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = aws_route_table.private_db.id
}
