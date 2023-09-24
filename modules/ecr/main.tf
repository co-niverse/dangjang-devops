### ECR private repository
resource "aws_ecr_repository" "repo" {
  name                 = var.env
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_iam_policy_document" "repo" {
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

resource "aws_ecr_repository_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.repo.json
}
