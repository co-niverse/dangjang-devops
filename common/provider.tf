terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "ap-northeast-2"
}
