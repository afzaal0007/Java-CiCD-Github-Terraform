# module "github_oidc" {
#   source = "./modules/iam/github-oidc"

#   github_org       = "afzaal0007"
#   github_repo      = "Java-CiCD-Github-Terraform"
#   state_bucket_arn = module.state_storage.bucket_arn
#   lock_table_arn   = module.state_lock.table_arn
#   cluster_name     = var.cluster_name
#   #tags             = var.tags
# }


resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.env}-main"
  }
}


# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }

data "aws_caller_identity" "current" {}


module "iam" {
  source = "./modules/iam"
  
  trusted_entities = var.trusted_entities
  tags            = var.tags
  github_org       = "afzaal0007"
  github_repo      = "Java-CiCD-Github-Terraform"
  # repository_names     = "Java-CiCD-Github-Terraform"
  # state_bucket_arn = module.state_storage.bucket_arn
  # lock_table_arn   = module.state_lock.table_arn
  cluster_name     = var.cluster_name
}



module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  aws_auth_users = var.aws_auth_users
  aws_auth_roles = var.aws_auth_roles
  tags           = var.tags
}



module "ecr" {
  source = "./modules/ecr"

  repository_names = var.repository_names
  tags            = var.tags
}