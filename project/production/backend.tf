terraform {
  backend "s3" {
    bucket = "dangjang-tfstate"
    key = "production/terraform-tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock-production"
  }
}