terraform {
  backend "s3" {
    bucket = "dangjang.terraform.tfstate"
    key = "terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-tfstate-lock"
  }
}
