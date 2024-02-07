###################
#       ECR       #
###################

### Policy
data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"
  statement {
    sid    = "AllowPullPushForTwo"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.identifiers
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

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.policy.json
}

### Lifecycle
resource "aws_ecr_lifecycle_policy" "lifecycle" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_count} images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

### Repository
resource "aws_ecr_repository" "repo" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  lifecycle {
    create_before_destroy = true
  }
}
