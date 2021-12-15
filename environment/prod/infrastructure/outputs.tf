output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_azs" {
  value = module.vpc.vpc_azs
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
}


output "cidr" {
  value = module.vpc.cidr
}