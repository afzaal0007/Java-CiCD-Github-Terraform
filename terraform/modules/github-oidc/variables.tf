variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the EKS cluster"
  type        = map(string)
  default     = {}
}

variable "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  type        = string
}

variable "lock_table_arn" {
  description = "ARN of the DynamoDB table for Terraform state locking"
  type        = string
} 

variable "github_OIDC_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
  default     = "arn:aws:iam::099199746132:oidc-provider/token.actions.githubusercontent.com"
}
