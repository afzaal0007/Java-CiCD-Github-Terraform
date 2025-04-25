output "eks_admin_role_arn" {
  value = length(aws_iam_role.eks_admin) > 0 ? aws_iam_role.eks_admin[0].arn : data.aws_iam_role.eks_admin_existing.arn
}

output "eks_admin_role_name" {
  value = length(aws_iam_role.eks_admin) > 0 ? aws_iam_role.eks_admin[0].name : data.aws_iam_role.eks_admin_existing.name
}
