resource "aws_ecr_repository" "prod" {
  name = "prod"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "prod" {
  repository = aws_ecr_repository.prod.name
}