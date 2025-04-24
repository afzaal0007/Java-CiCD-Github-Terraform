variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default     = ["myapp"]
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for ECR (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for encryption when encryption_type is KMS"
  type        = string
  default     = null
}

variable "keep_last_images" {
  description = "Number of images to retain in the repository"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "List of lifecycle rule configurations"
  type = list(object({
    rulePriority = number
    description  = string
    tagStatus    = string
    tagPrefixes  = optional(list(string))
    countType    = string
    countNumber  = number
  }))
  default = [{
    rulePriority = 1
    description  = "Keep last 30 images"
    tagStatus    = "any"
    countType    = "imageCountMoreThan"
    countNumber  = 30
  }]
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle policy for the repositories"
  type        = bool
  default     = true
}