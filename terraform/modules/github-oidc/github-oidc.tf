
resource "aws_iam_role" "github_actions_role" {
  name = "afzaal-GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = var.github_OIDC_provider_arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repository}:*"
          }
        }
      }
    ]
  })
}

# Optionally, attach the policy (as defined in previous examples) to the role created.  
resource "aws_iam_policy" "github_oidc_policy" {  
  name        = "GitHubActionsFullAccessPolicy"  
  description = "Policy for GitHub Actions to access AWS resources"  
  policy      = jsonencode({  
    Version = "2012-10-17",  
    Statement = [  
      {  
        Effect = "Allow",  
        Action = [  
          "sts:AssumeRole",  
          "ecr:*",  
          "ec2:*",  
          "eks:*",  
          "s3:*",  
          "dynamodb:*"  
        ],  
        Resource = "*",  
        Condition = {  
          StringEquals = {  
            "sts:ExternalId" = "repo:${var.github_organization}/${var.github_repository}",  
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repository}:ref:refs/heads/main"  
          }  
        }  
      }  
    ]  
  })  
}  

# Attach the policy to the role  
resource "aws_iam_policy_attachment" "attach_github_policy" {  
  name       = "attach_github_oidc_policy"  
  roles      = [aws_iam_role.github_actions_role.name]  
  policy_arn = aws_iam_policy.github_oidc_policy.arn  
}  

resource "aws_iam_role_policy_attachment" "github_actions_eks" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ECR Policy Attachment
resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# VPC Policy Attachment
resource "aws_iam_role_policy_attachment" "github_actions_vpc" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "github_actions_iam" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}