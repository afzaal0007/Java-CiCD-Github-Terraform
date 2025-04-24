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