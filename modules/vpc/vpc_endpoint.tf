###################
#       VPC       #
###################

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_route_table.private.id]

  tags = {
    Name = "s3-endpoint-${var.env}"
  }
}

resource "aws_vpc_endpoint" "kinesis" {
  vpc_id = aws_vpc.default.id
  service_name = "com.amazonaws.${var.aws_region}.kinesis-streams"
  vpc_endpoint_type = "Interface"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name = "kinesis-endpoint-${var.env}"
  }
}