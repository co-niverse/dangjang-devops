###################
#   OpenSearch    #
###################

output "log_opensearch_arn" {
  value = aws_opensearch_domain.log_opensearch.arn
}