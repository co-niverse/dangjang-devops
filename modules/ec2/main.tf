###################
#       EC2       #
###################

resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.pulic_ip_enabled

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  source_dest_check      = var.source_dest_check

  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    tags = {
      Name = var.ebs_name
    }
  }

  tags = {
    Name = var.instance_name
  }
}
