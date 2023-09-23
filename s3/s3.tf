resource "aws_s3_bucket" "client-log" {
  bucket = "dangjang.client.log"
}

resource "aws_s3_bucket" "server-log" {
  bucket = "dangjang.server.log"
}

resource "aws_s3_bucket" "user-image" {
  bucket = "dangjang.user.image"
}
