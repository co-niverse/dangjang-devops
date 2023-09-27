###################
#       EC2       #
###################

### Mongo
resource "aws_instance" "mongo" {
  count         = ("${var.env}" == "prod" || "${var.env}" == "staging") ? 3 : 1
  ami           = "ami-00fdfe418c69b624a"
  instance_type = var.mongo_instance_type
  key_name      = "${var.env}-server-key-pair"

  subnet_id              = element(var.private_db_subnets, count.index)
  vpc_security_group_ids = [var.mongo_security_group_id]

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 30
  }

  tags = {
    Name = (count.index == 2) ? "mongodb-primary-${var.env}" : "mongodb-secondary${count.index + 1}-${var.env}"
  }
}

### Bastion
resource "aws_instance" "bastion" {
  count                       = ("${var.env}" == "prod" || "${var.env}" == "staging") ? 1 : 0
  ami                         = "ami-00fdfe418c69b624a"
  instance_type               = "t4g.micro"
  key_name                    = "${var.env}-server-key-pair"
  associate_public_ip_address = true

  subnet_id              = var.public_bastion_subnet
  vpc_security_group_ids = [var.default_security_group_id]

  tags = {
    Name = "bastion-${var.env}"
  }
}
