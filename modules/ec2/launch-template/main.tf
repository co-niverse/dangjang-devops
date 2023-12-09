data "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name
}

resource "aws_iam_instance_profile" "profile" {
  name = var.profile_name
  role = data.aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "template" {
  name                   = var.template_name
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      ecs_cluster_name = var.ecs_cluster_name
    })
  )

  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_type = var.volume_type
      volume_size = var.volume_size
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  monitoring {
    enabled = var.enabled_monitoring
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = var.ebs_tag_name
    }
  }
}
