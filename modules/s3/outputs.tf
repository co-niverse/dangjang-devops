###################
#       S3        #
###################

output "client_log_arn" {
  value = aws_s3_bucket.client-log.arn
}

output "server_log_arn" {
  value = aws_s3_bucket.server-log.arn
}

output "user_image_arn" {
  value = aws_s3_bucket.user-image.arn
}