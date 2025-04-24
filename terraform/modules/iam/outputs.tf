output "eks_admin_role_arn" {
  description = "ARN of the EKS admin role"
  value       = aws_iam_role.eks_admin.arn
}

output "eks_admin_role_name" {
  description = "Name of the EKS admin role"
  value       = aws_iam_role.eks_admin.name
}


