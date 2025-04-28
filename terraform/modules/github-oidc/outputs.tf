# outputs.tf
output "github_actions_role_arn" {
  description = "ARN of IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_oidc_provider_arn" {
  description = "ARN of GitHub Actions OIDC Provider"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "github_actions_role_name" {
  description = "Name of IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.name
}