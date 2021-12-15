module "vpc" {

  #https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest 

  source = "../../../modules/vpc"

  environment = "my-tf-vpc"
  
  cidr = "10.100.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  private_subnets = ["10.100.1.0/24", "10.100.2.0/24"]
  public_subnets  = ["10.100.101.0/24", "10.100.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = false

}
