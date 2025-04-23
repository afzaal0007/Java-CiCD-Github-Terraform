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