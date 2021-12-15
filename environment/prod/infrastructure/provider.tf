terraform {
  backend "s3" {
    bucket = "my-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

