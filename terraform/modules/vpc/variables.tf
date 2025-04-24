variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}


variable "zone1" {
  description = "Availability zone 1"
  type        = string
  default     = "ap-south-1a"
}
variable "zone2" {
  description = "Availability zone 2"
  type        = string
  default     = "ap-south-1b"
}