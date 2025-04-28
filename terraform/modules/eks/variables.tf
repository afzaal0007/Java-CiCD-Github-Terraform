variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}



variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}
variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}


variable "node_group_size" {
  description = "Size of the EKS node group"
  type        = number
  default     = 2
}
variable "aws_auth_users" {
  description = "List of IAM users to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}
variable "aws_auth_roles" {
  description = "List of IAM roles to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "repository_name" {
  description = "List of ECR repository names"
  type        = string
  default     = "afzaal-ecr-repo"
}

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.31"
}

# create a variable of type list for cluster_enabled_log_types
variable "cluster_enabled_log_types" {
  description = "List of cluster enabled log types"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
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

# variable node_group_instance_type
variable "node_group_instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
  default     = "t3.medium"
}


variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev" # You can change this default value as needed
}
