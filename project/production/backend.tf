terraform {
  backend "s3" {
    bucket = "dangjang.tfstate"
    key = "production/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock-production"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-lock-production"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }  
}