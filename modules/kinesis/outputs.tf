###################
#     Kinesis     #
###################

output "client_log_arn" {
  value = aws_kinesis_stream.client_log.arn
}

output "server_log_arn" {
  value = aws_kinesis_stream.server_log.arn
}

output "kinesis_role_arn" {
  value = aws_iam_role.kinesis_role.arn
}