module "github_oidc" {
  source = "./modules/iam/github-oidc"

  github_org       = "your-org"
  github_repo      = "your-repo"
  state_bucket_arn = module.state_storage.bucket_arn
  lock_table_arn   = module.state_lock.table_arn
  cluster_name     = var.cluster_name
  tags             = var.tags
}

module "vpc" {
  source = "./modules/vpc"

  cluster_name    = var.cluster_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags            = var.tags
}


module "state_storage" {
  source = "./modules/s3"

  bucket_name        = "${var.cluster_name}-tf-state-${data.aws_caller_identity.current.account_id}"
  enable_bucket_policy = true
  tags              = var.tags
}

module "state_lock" {
  source = "./modules/dynamodb"

  table_name = "${var.cluster_name}-tf-locks"
  tags       = var.tags
}

data "aws_caller_identity" "current" {}


module "iam" {
  source = "./modules/iam"

  cluster_name     = var.cluster_name
  trusted_entities = var.trusted_entities
  tags            = var.tags
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