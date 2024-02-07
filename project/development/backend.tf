terraform {
  backend "s3" {
    bucket = "dangjang-tfstate"
    key = "development/terraform-tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock-development"
  }
}