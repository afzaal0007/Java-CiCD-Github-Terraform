# module "github_oidc" {
#   source = "./modules/iam/github-oidc"

#   github_org       = "afzaal0007"
#   github_repo      = "Java-CiCD-Github-Terraform"
#   state_bucket_arn = module.state_storage.bucket_arn
#   lock_table_arn   = module.state_lock.table_arn
#   cluster_name     = var.cluster_name
#   #tags             = var.tags
# }


module "vpc" {
  source = "./modules/vpc"
 }

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}


module "iam" {
  source = "./modules/iam"
  
  trusted_entities = var.trusted_entities
  tags            = local.tags
  github_org       = "afzaal0007"
  github_repo      = "Java-CiCD-Github-Terraform"
  # repository_names     = "Java-CiCD-Github-Terraform"
  # state_bucket_arn = module.state_storage.bucket_arn
  # lock_table_arn   = module.state_lock.table_arn
  cluster_name     = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = local.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = [module.vpc.private_subnet1_id, module.vpc.private_subnet2_id]
  public_subnets  = [module.vpc.public_subnet1_id, module.vpc.public_subnet2_id]
  eks_version     = local.eks_version
  node_group_name = local.node_group_name
  node_group_size = local.node_group_size
  # aws_auth_users = local.aws_auth_users
  # aws_auth_roles = local.aws_auth_roles
  tags           = local.tags
}



module "ecr" {
  source = "./modules/ecr"

  repository_names = var.repository_names
  tags            = local.tags
}