output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

# Outputs for travel-app-1
output "ecs_travel_app_1_cluster_id" {
  value = module.ecs_travel_app.ecs_cluster_id
}

output "ecs_travel_app_1_service_name" {
  value = module.ecs_travel_app.ecs_service_name
}


output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}