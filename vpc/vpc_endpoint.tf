resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.prod.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}
