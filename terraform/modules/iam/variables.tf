variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "trusted_entities" {
  description = "List of ARNs that can assume this role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "state_bucket_arn" {
  description = "ARN of the S3 state bucket"
  type        = string
}

variable "lock_table_arn" {
  description = "ARN of the DynamoDB lock table"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)

}