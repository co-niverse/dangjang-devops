locals {
  delete_image_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "ecr_policy" {
  version = "2012-10-17"
  statement {
    sid    = "AllowPullPushForTwo"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::503792100451:user/teo", "arn:aws:iam::503792100451:user/eve"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
  }
}

resource "aws_ecr_repository_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy     = local.delete_image_policy
}

resource "aws_ecr_repository_policy" "fluendbit" {
  repository = aws_ecr_repository.fluentbit.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_ecr_lifecycle_policy" "fluendbit" {
  repository = aws_ecr_repository.fluentbit.name
  policy     = local.delete_image_policy
}