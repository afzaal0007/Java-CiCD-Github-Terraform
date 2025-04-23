variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state storage"
  type        = string
}

variable "enable_bucket_policy" {
  description = "Whether to enable the strict bucket policy that enforces encryption and TLS"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}