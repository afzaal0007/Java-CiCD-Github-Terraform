output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "eks_admin_role_arn" {
  description = "ARN of the EKS admin role"
  value       = module.iam.eks_admin_role_arn
}

output "ecr_repository_urls" {
  description = "repository names to repository URLs"
  value       = module.ecr.repository_url
}

# output "github_actions_role_arn" {
#   description = "ARN of the GitHub OIDC role"
#   value       = module.github_oidc.github_actions_role_arn
# }
# output "github_actions_role_id" {
#   description = "ID of the GitHub OIDC role"
#   value       = module.github_oidc.github_actions_role_id
# }
# output "github_actions_role_name" {
#   description = "Name of the GitHub OIDC role"
#   value       = module.github_oidc.github_actions_role_name
# }