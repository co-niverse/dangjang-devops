###################
#     Kinesis     #
###################

output "client_log" {
  value = aws_kinesis_stream.client_log.id
}

output "server_log" {
  value = aws_kinesis_stream.server_log.id
}

output "kinesis_role_arn" {
  value = aws_iam_role.kinesis_role.arn
}