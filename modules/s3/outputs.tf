output "arn" {
  value = aws_s3_bucket.bucket.arn
}

output "domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}