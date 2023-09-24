resource "aws_s3_bucket" "client-log" {
  bucket = "dangjang.client.log-${var.env}"
}

resource "aws_s3_bucket" "server-log" {
  bucket = "dangjang.server.log-${var.env}"
}

resource "aws_s3_bucket" "user-image" {
  bucket = "dangjang.user.image-${var.env}"
}
