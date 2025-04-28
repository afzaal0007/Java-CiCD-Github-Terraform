variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "github_OIDC_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}
