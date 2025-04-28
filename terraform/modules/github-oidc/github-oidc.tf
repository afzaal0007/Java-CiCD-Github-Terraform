# github-oidc.tf
# Get GitHub OIDC Provider thumbprint
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# Create OIDC Provider
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

# Create IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "github-actions-oidc-role"

  # Trust relationship policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : [
              "repo:${var.github_org}/${var.github_repo}:*"
            ]
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "github-actions-oidc-role"
    Environment = "production"
    Terraform   = "true"
  }
}

# Create IAM Policy for Terraform operations
resource "aws_iam_policy" "terraform_policy" {
  name        = "terraform-deployment-policy"
  description = "Policy for Terraform deployments via GitHub Actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # S3 permissions for Terraform state
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",

          # DynamoDB permissions for state locking
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",

          # EC2 permissions
          "ec2:*",

          # IAM permissions
          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:GetUser",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "iam:PassRole",

          # VPC permissions
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",

          # Security Group permissions
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",

          # EKS permissions if needed
          "eks:*",

          # CloudWatch Logs permissions
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:DeleteLogGroup",

          # ECR permissions if needed
          "ecr:*",

          # Additional permissions based on your needs
          "elasticloadbalancing:*",
          "autoscaling:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "terraform-deployment-policy"
    Environment = "production"
    Terraform   = "true"
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "terraform_policy_attachment" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}

