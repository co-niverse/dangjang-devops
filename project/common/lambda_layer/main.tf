###################
#  Lambda Layer   #
###################

locals {
  fcm_layer_dir_path = "../../function/layer/firebase_admin/"
  fcm_layer_zip_path = "../../function/layer/firebase_admin.zip"
  runtimes           = ["python3.11"]
  architectures      = ["arm64"]
}

data "archive_file" "fcm_init" {
  type        = "zip"
  source_dir  = local.fcm_layer_dir_path
  output_path = local.fcm_layer_zip_path
}

resource "aws_lambda_layer_version" "fcm_layer" {
  layer_name               = "fcm_layer"
  compatible_runtimes      = local.runtimes
  compatible_architectures = local.architectures
  filename                 = local.fcm_layer_zip_path
  source_code_hash         = data.archive_file.fcm_init.output_base64sha256
}
