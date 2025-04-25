locals {
  env                      = "dev"
  region                   = "ap-south-1"
  zone1                    = "ap-south-1a"
  zone2                    = "ap-south-1b"
  cluster_name             = "eks-spring"
  eks_version              = "1.31"
  vpc_cidr                 = "10.0.0.0/16"
  private_subnet1_cidr     = "10.0.0.0/19"
  private_subnet2_cidr     = "10.0.32.0/19"
  public_subnet1_cidr      = "10.0.64.0/19"
  public_subnet2_cidr      = "10.0.96.0/19"
  node_group_name          = "general"
  node_group_size          = 2
  node_group_instance_type = "t2.medium"
  node_group_min_size      = 1
  node_group_max_size      = 3
  node_group_desired_size  = 2
  tags = {
    Name        = "${local.cluster_name}-${local.env}"
    Environment = local.env
    Project     = "EKS"
  }
}