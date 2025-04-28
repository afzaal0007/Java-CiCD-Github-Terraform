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
  default     = "10.0.1.0/24"
}

# variable for private subnet 2 cidr
variable "priv-subnet2-cidr" {
  description = "CIDR block for the private subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

# variable for public subnet 1 cidr

variable "pub-subnet1-cidr" {
  description = "CIDR block for the public subnet 1"
  type        = string
  default     = "10.0.101.0/24"
}

# variable for public subnet 2 cidr
variable "pub-subnet2-cidr" {
  description = "CIDR block for the public subnet 2"
  type        = string
  default     = "10.0.102.0/24"
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "tags" {
  description = "Tags to be applied to the VPC and subnets"
  type        = map(string)
  default     = {}
}