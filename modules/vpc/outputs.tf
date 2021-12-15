output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_azs" {
  value = module.vpc.azs
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "cidr" {
  value = module.vpc.vpc_cidr_block
}