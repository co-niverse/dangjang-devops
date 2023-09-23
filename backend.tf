terraform {
  backend "remote" {
    organization = "dangjang"
    workspaces {
      name = "dangjang-devops"
    }
  }
}
