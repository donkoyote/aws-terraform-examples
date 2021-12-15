terraform {
  backend "s3" {
    bucket = "my-state-bucket"
    key    = "compute.tfstate"
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
  default_tags {
    tags = {
      Environment = "Production"
    }
  }
}

