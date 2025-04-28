variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "afzaal-ecr-repo" # Replace with your repository name
}

output "lifecycle_policy_text" {
  description = "The lifecycle policy text"
  value       = aws_ecr_lifecycle_policy.this.policy
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
