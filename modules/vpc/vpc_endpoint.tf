resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  tags = {
    Name = "s3-endpoint-${var.env}"
  }
}
