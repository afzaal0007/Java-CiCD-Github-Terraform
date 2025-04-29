# Check if the IAM role exists
data "aws_iam_role" "eks_admin_existing" {
  name = "eks-admin"
}

# Create the IAM role only if it does NOT exist
resource "aws_iam_role" "eks_admin" {
  count = data.aws_iam_role.eks_admin_existing.name != null ? 0 : 1
  name  = "eks-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { AWS = "arn:aws:iam::099199746132:root" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "eks_admin" {
  name        = "eks-admin-policy"
  description = "IAM policy for EKS admin role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "eks:DescribeCluster",
        "eks:ListNodegroups",
        "eks:AccessKubernetesApi",
        "iam:PassRole"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "eks_admin_worker" {
  name        = "eks-admin-worker-policy"
  description = "IAM policy for EKS worker nodes"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ec2:DescribeInstances",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "eks_admin_cni" {
  name        = "eks-admin-cni-policy"
  description = "IAM policy for Amazon VPC CNI plugin"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ec2:DescribeNetworkInterfaces",
        "ec2:AttachNetworkInterface"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "eks_admin_ecr" {
  name        = "eks-admin-ecr-policy"
  description = "IAM policy for ECR access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages",
        "ecr:DescribeImages"
      ],
      Resource = "*"
    }]
  })
}



resource "aws_iam_role_policy_attachment" "eks_admin" {
  count      = length(aws_iam_role.eks_admin) > 0 ? 1 : 0
  role       = aws_iam_role.eks_admin[count.index].name
  policy_arn = aws_iam_policy.eks_admin.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_admin_worker" {
  count      = length(aws_iam_role.eks_admin) > 0 ? 1 : 0
  role       = aws_iam_role.eks_admin[count.index].name
  policy_arn = aws_iam_policy.eks_admin_worker.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_admin_cni" {
  count      = length(aws_iam_role.eks_admin) > 0 ? 1 : 0
  role       = aws_iam_role.eks_admin[count.index].name
  policy_arn = aws_iam_policy.eks_admin_cni.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_admin_ecr" {
  count      = length(aws_iam_role.eks_admin) > 0 ? 1 : 0
  role       = aws_iam_role.eks_admin[count.index].name
  policy_arn = aws_iam_policy.eks_admin_ecr.arn

  lifecycle {
    create_before_destroy = true
  }
}
