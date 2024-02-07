resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type
  final_snapshot    = var.final_snapshot

  tags = {
    Name = var.name
  }
}

resource "aws_volume_attachment" "attachment" {
  device_name  = var.device_name
  volume_id    = aws_ebs_volume.volume.id
  instance_id  = var.instance_id
}
