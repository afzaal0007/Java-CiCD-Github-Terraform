variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.26"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
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

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}