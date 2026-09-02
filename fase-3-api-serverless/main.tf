terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "logitrack-939603205666-us-east-2-an"
    key     = "fase-3-serverless/terraform.tfstate" # Chave exclusiva para isolar esta fase
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}

