###################
#     Kinesis     #
###################

output "client_log_arn" {
  value = aws_kinesis_stream.client_log.arn
}

output "server_log_arn" {
  value = aws_kinesis_stream.server_log.arn
}

output "notification_arn" {
  value = aws_kinesis_stream.notification.arn
}