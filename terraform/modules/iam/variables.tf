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
