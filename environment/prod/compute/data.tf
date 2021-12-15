data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
