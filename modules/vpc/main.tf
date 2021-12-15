module "vpc" {
  #https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "${var.environment}-vpc"

  azs  = var.azs
  cidr = var.cidr

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = var.single_nat_gateway
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    terraform   = "true"
    environment = "${var.environment}"
  }
}

// resource "aws_security_group" "endpoint" {
//   name        = "endpoint_vpc_traffic"
//   description = "Allow ALL from vpc"
//   vpc_id      = module.vpc.vpc_id

//   ingress {
//     description      = ""
//     from_port        = 0
//     to_port          = 0
//     protocol         = "-1"
//     cidr_blocks      = [var.cidr]
//   }

//   egress {
//     from_port        = 0
//     to_port          = 0
//     protocol         = "-1"
//     cidr_blocks      = ["0.0.0.0/0"]
//   }

//   tags = {
//     Name = "endpoint_vpc_traffic"
//   }
// }

// module "vpc_endpoints" {
//   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

//   vpc_id             = module.vpc.vpc_id
//   security_group_ids = [aws_security_group.endpoint.id]


//   endpoints = {
//     s3 = {
//       service = "s3"
//       tags    = { Name = "s3-vpc-endpoint" }
//     },
//     ssm = {
//       service             = "ssm"
//       private_dns_enabled = true
//       subnet_ids          = module.vpc.private_subnets
//     }
//   }
// }
