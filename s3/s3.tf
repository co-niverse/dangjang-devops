resource "aws_s3_bucket" "client-log" {
  bucket = "dangjang.client.log"
}

resource "aws_s3_bucket" "server-log" {
  bucket = "dangjang.server.log"
}

resource "aws_s3_bucket" "user-image" {
  bucket = "dangjang.user.image"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "dangjang.terraform.tfstate"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket
  versioning_configuration {
    status = "Enabled"
  }
}