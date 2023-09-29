###################
#       ECR       #
###################

output "app_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "fluentbit_repository_url" {
  value = aws_ecr_repository.fluentbit.repository_url
}