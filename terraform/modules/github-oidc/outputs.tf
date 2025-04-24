
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