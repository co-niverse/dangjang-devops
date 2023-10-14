###################
#  Lambda Layer   #
###################

data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.dir_path
  output_path = var.zip_path
}

resource "aws_lambda_layer_version" "layer" {
  layer_name               = var.layer_name
  compatible_runtimes      = var.runtimes
  compatible_architectures = var.architectures
  filename                 = var.zip_path
  source_code_hash         = data.archive_file.init.output_base64sha256
}
