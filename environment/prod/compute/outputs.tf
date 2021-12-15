output "dns_name" {
  value = module.alb.dns_name
}

output "private_ip" {
  value = module.ec2.private_ip
}