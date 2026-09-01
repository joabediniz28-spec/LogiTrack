terraform {
  backend "s3" {
    bucket  = "logitrack-939603205666-us-east-2-an"
    key     = "estudos/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}
