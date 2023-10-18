###################
#       ECR       #
###################

### ECR private repository - app
resource "aws_ecr_repository" "app" {
  name                 = var.env
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

### ECR private repository - fluentbit
resource "aws_ecr_repository" "fluentbit" {
  name                 = "fluentbit-${var.env}"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete


  image_scanning_configuration {
    scan_on_push = true
  }
}
