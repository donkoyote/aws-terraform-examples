module "ec2" {
  source      = "../../../modules/ec2"

  subnet_id  = "${element(data.terraform_remote_state.vpc.outputs.vpc_private_subnets, 0)}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  name                               = "my-tf-ec2"
  key_name                           = ""

  instance_type         = "t3.small"
}

module "alb" {
  source = "../../../modules/alb"

  name = "my-tf-alb"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets = [data.terraform_remote_state.vpc.outputs.vpc_public_subnets[0],data.terraform_remote_state.vpc.outputs.vpc_public_subnets[1]]
  private_subnets = [data.terraform_remote_state.vpc.outputs.vpc_private_subnets[0],data.terraform_remote_state.vpc.outputs.vpc_private_subnets[1]]
  vpc_azs = data.terraform_remote_state.vpc.outputs.vpc_azs

}