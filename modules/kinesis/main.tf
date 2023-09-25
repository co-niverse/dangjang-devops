resource "aws_kinesis_stream" "client_log" {
  name             = "kn-client-log-${var.env}"
  shard_count      = var.shard_count

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

resource "aws_kinesis_stream" "server_log" {
  name             = "kn-server-log-${var.env}"
  shard_count      = var.shard_count

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
