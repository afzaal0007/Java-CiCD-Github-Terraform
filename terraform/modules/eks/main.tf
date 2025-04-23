module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_groups = {
    apps = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = "apps"
      }
    }

    system = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = "system"
      }

      taints = {
        dedicated = {
          key    = "system"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = var.aws_auth_users
  aws_auth_roles = var.aws_auth_roles

  tags = var.tags
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = "v1.12.6-eksbuild.2"
  service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = module.eks.cluster_name
  addon_name        = "coredns"
  addon_version     = "v1.9.3-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = module.eks.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = "v1.26.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "${var.cluster_name}-vpc-cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = var.tags
}

module "load_balancer_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${var.cluster_name}-lb-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = var.tags
}

module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "${var.cluster_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = var.tags
}