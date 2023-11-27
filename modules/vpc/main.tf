###################
#       VPC       #
###################

# VPC CIDR will use the B class with 10.x.0.0/16
resource "aws_vpc" "default" {
  cidr_block           = "10.${var.cidr_numeral}.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.igw_name
  }
}
