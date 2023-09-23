# Default Security Group
resource "aws_security_group" "prod" {
  name   = "prod-sg-${var.vpc_name}"
  vpc_id = aws_vpc.prod.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ELB
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ELB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0s.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
