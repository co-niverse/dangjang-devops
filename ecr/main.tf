### ECR private repository
resource "aws_ecr_repository" "prod" {
  name                 = "prod"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_iam_policy_document" "prod" {
  version = "2012-10-17"
  statement {
    sid = "AllowPullPushForOne"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::503792100451:user/teo"]
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

resource "aws_ecr_repository_policy" "prod" {
  repository = aws_ecr_repository.prod.name
  policy = data.aws_iam_policy_document.prod.json
}
