
# backend.tf
terraform {
  backend "s3" {
    bucket         = "become-techgeek-tfstate-demo"
    key            = "ecs-infra/terraform.tfstate"  # (like a folder path)
    region         = "us-east-1"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }
}

# ---------------------------
# VPC Module
# ---------------------------
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "122.2.0.0/16"
  public_subnet_cidrs = ["122.2.1.0/24", "122.2.2.0/24"]
  private_subnet_cidrs = ["122.2.3.0/24", "122.2.4.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]
}

# ---------------------------
# Security Groups Module
# ---------------------------
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# ---------------------------
# ALB Module
# ---------------------------
module "alb" {
  source             = "./modules/alb"
  alb_name           = "gateway-alb"
  public_subnets     = module.vpc.public_subnets
  alb_sg_id          = module.security_groups.alb_sg_id
  target_group_name  = "gateway-target-group"
  vpc_id             = module.vpc.vpc_id
}

# ---------------------------
# ECS (Fargate) Module
# ---------------------------
# ECS Service for travel-app-1
module "ecs_travel_app" {
  source              = "./modules/ecs"
  cluster_name        = "Tapp-Cluster"
  task_family         = "travel-app-1-family"
  task_cpu            = "1024"
  task_memory         = "2048"
  ephemeral_storage_size = 30
  container_name      = "travel-app-1"
  container_image     = "rajmohanb/travel-app:amd64"
  container_port      = 80
  execution_role_arn  = "arn:aws:iam::442426856256:role/ecsTaskExecutionRole"
  task_role_arn       = "arn:aws:iam::442426856256:role/ecsTaskExecutionRole"
  service_name        = "travel-app-1-service"
  desired_count       = 2
  private_subnets     = module.vpc.private_subnets
  ecs_sg_id           = module.security_groups.ecs_sg_id
  target_group_arn    = module.alb.target_group_arn_app1
  alb_listener        = module.alb.alb_listener_arn
}

# ---------------------------
# Bastion Host Module
# ---------------------------
module "bastion" {
  source           = "./modules/bastion"
  ami_id           = "ami-005fc0f236362e99f"  # Ubuntu 22.04 AMI
  instance_type    = "t3.micro"
  public_subnet_id = module.vpc.public_subnets[0]
  bastion_sg_id    = module.security_groups.alb_sg_id
  key_name         = "lx-mac-con-key"
}
