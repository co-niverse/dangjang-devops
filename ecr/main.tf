resource "aws_ecr_repository" "prod" {
  name                 = "prod"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "prod" {
  repository = aws_ecr_repository.prod.name
    policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.expiration_after_days} days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.expiration_after_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

  # policy = jsonencode({
  #   rules = [
  #     {
  #       rulePriority = 1
  #       description  = "Expire images older than ${var.expiration_after_days} days",
  #       selection = {
  #         tagStatus   = "any"
  #         countType   = "sinceImagePushed"
  #         countUnit   = "days"
  #         countNumber = var.expiration_after_days
  #       }
  #       action = {
  #         type = "expire"
  #       }
  #     }
  #   ]
  # })