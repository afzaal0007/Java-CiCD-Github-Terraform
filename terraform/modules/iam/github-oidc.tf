resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's OIDC thumbprint

  tags = merge(var.tags, {
    Name = "github-oidc-provider"
  })
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${var.github_org}/${var.github_repo}:*",
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/*",
        "repo:${var.github_org}/${var.github_repo}:pull_request"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.cluster_name}-github-actions-role"
  description        = "IAM role for GitHub Actions CI/CD pipeline"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = merge(var.tags, {
    Name = "github-actions-role"
  })
}

# EKS Policy Attachment
resource "aws_iam_role_policy_attachment" "github_actions_eks" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ECR Policy Attachment
resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# S3 State Access Policy
resource "aws_iam_policy" "github_actions_s3" {
  name        = "${var.cluster_name}-github-actions-s3"
  description = "Permissions for GitHub Actions to access Terraform state bucket"
  policy      = data.aws_iam_policy_document.github_actions_s3.json
}

resource "aws_iam_role_policy_attachment" "github_actions_s3" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_s3.arn
}

# DynamoDB Lock Table Policy
resource "aws_iam_policy" "github_actions_dynamodb" {
  name        = "${var.cluster_name}-github-actions-dynamodb"
  description = "Permissions for GitHub Actions to access Terraform lock table"
  policy      = data.aws_iam_policy_document.github_actions_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "github_actions_dynamodb" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_dynamodb.arn
}

# S3 Policy Document
data "aws_iam_policy_document" "github_actions_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::myapp-tf-state-099199746132",
      "arn:aws:s3:::myapp-tf-state-099199746132/*"
    ]
  }
}

# DynamoDB Policy Document
data "aws_iam_policy_document" "github_actions_dynamodb" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:ap-south-1:099199746132:table/terraform-locks"]
  }
}

# Additional Deployment Policy (if needed)
resource "aws_iam_role_policy" "github_actions_deploy" {
  name   = "${var.cluster_name}-github-actions-deploy"
  role   = aws_iam_role.github_actions.name
  policy = data.aws_iam_policy_document.github_actions_deploy.json
}

data "aws_iam_policy_document" "github_actions_deploy" {
  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["*"]
  }
}