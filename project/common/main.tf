module "s3" {
  source = "./s3"
}

module "iam" {
  source = "./iam"
}

module "lambda_layer" {
  source = "./lambda_layer"
}
