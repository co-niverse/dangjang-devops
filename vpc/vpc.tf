# VPC
# VPC CIDR will use the B class with 10.x.0.0/16
resource "aws_vpc" "prod" {
  cidr_block = "10.${var.cidr_numeral}.0.0/16"
  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}


### NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat-gw-${var.vpc_name}"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}


### Public Subnets
# Subnet will use cidr with /24 -> The number of available IP is 256
resource "aws_subnet" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.prod.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  # Public IP will be assigned automatically when the instance is launch in the public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sb${count.index}-${var.vpc_name}"
  }
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "public-rt-${var.vpc_name}"
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
  vpc_id = aws_vpc.prod.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-sb${count.index}-${var.vpc_name}"
  }
}

# Route Table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "private-rt-${var.vpc_name}"
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
  vpc_id = aws_vpc.prod.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_db[count.index]}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-db-sb${count.index}-${var.vpc_name}"
  }
}

# Route Table for DB subnets
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "private-db-rt-${var.vpc_name}"
  }
}

# Route Table Association for DB subnets
resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = aws_route_table.private_db.id
}
