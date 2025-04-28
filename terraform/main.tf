

# Enable GitHub OIDC for secure authentication
module "github_oidc" {
  source      = "./modules/github-oidc"
  github_org  = var.github_org
  github_repo = var.github_repo

}


# VPC Configuration
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = merge(local.tags, {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  })
}

# Get cluster info
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

# IAM Configuration
module "iam" {
  source = "./modules/iam"

  trusted_entities = var.trusted_entities
  tags             = local.tags

  cluster_name = var.cluster_name
}

# EKS Configuration
module "eks" {
  source = "./modules/eks"

  cluster_name    = local.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = [module.vpc.private_subnet1_id, module.vpc.private_subnet2_id]
  public_subnets  = [module.vpc.public_subnet1_id, module.vpc.public_subnet2_id]
  eks_version     = local.eks_version

  node_group_name          = local.node_group_name
  node_group_size          = local.node_group_size
  node_group_instance_type = "t3.medium"

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = local.tags
}

# ECR Repository
module "ecr" {
  source = "./modules/ecr"

  repository_name = "afzaal-ecr-repo"
  tags            = local.tags
  scan_on_push    = true
}