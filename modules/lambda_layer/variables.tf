###################
#  Lambda Layer   #
###################

variable "layer_name" {
  type = string
}
  
variable "dir_path" {
  type = string
}

variable "zip_path" {
  type = string
}

variable "runtimes" {
  type = list(string)
  default = ["python3.11"]
}
  
variable "architectures" {
  type = list(string)
  default = ["arm64"]
}
