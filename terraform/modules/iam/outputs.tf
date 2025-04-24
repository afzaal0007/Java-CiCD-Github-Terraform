output "eks_admin_role_arn" {
  description = "ARN of the EKS admin role"
  value       = aws_iam_role.eks_admin.arn
}

output "eks_admin_role_name" {
  description = "Name of the EKS admin role"
  value       = aws_iam_role.eks_admin.name
}



output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_role_id" {
  description = "ARN of the GitHub Actions IAM role id"
  value       = aws_iam_role.github_actions.id
}

output "github_actions_role_name" {
  description = "ARN of the GitHub Actions IAM role"
  value       = aws_iam_role.github_actions.name
}