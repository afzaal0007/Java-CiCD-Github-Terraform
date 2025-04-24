output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks.endpoint
}

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks.cluster_security_group_id
# }

# output "oidc_provider_arn" {
#   description = "ARN of the OIDC provider"
#   value       = module.eks.oidc_provider_arn
# }

# output "eks_managed_node_groups" {
#   description = "Map of attribute maps for all EKS managed node groups created"
#   value       = module.eks.eks_managed_node_groups
# }