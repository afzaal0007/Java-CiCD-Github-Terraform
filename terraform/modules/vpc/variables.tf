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

variable "eks_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-spring"
}

# variable "cluster_version" {
#   description = "EKS cluster version"
#   type        = string
#   default     = "1.31"
  
# }

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

# variable for private subnet 1 cidr
variable "priv-subnet1-cidr" {
  description = "CIDR block for the private subnet 1"
  type        = string
  default     = "10.0.0.0/19"
}

# variable for private subnet 2 cidr
variable "priv-subnet2-cidr" {
  description = "CIDR block for the private subnet 2"
  type        = string
  default     = "10.0.32.0/19"
}

# variable for public subnet 1 cidr

variable "pub-subnet1-cidr" {
  description = "CIDR block for the public subnet 1"
  type        = string
  default     = "10.0.64.0/19"
}

# variable for public subnet 2 cidr
variable "pub-subnet2-cidr" {
  description = "CIDR block for the public subnet 2"
  type        = string
  default     = "10.0.96.0/19"
}
