resource "aws_ecr_repository" "prod" {
  name = "prod"
}

resource "aws_ecr_repository_policy" "prod" {
  repository = aws_ecr_repository.prod.name
}