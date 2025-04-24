variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "myapp-eks"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "aws_auth_users" {
  description = "List of user ARNs to add to aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_roles" {
  description = "List of role ARNs to add to aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "trusted_entities" {
  description = "List of ARNs that can assume the IAM role"
  type        = list(string)
  default     = []
}

variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default     = ["myapp"]
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "enable_state_storage" {
  description = "Whether to create S3 bucket and DynamoDB table for Terraform state"
  type        = bool
  default     = true
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "myapp-tf-state-099199746132"
}

variable "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  type        = string
  default     = "arn:aws:s3:::myapp-tf-state-099199746132"
}

variable "lock_table_arn" {
  description = "ARN of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "arn:aws:dynamodb:ap-south-1:099199746132:table/terraform-locks"
}


variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-locks"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "afzaal0007"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "Java-CiCD-Github-Terraform"
}

variable "github_branch" {
  description = "GitHub branch name"
  type        = string
  default     = "main"
}

variable "github_token" {
  description = "GitHub token for accessing the repository"
  type        = string
  default     = ""
}

variable "github_token_secret" {
  description = "GitHub token secret for accessing the repository"
  type        = string
  default     = ""
}

variable "github_token_id" {
  description = "GitHub token ID for accessing the repository"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.31"
}

variable "cluster_enabled_log_types" {
  description = "List of cluster enabled log types"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
  