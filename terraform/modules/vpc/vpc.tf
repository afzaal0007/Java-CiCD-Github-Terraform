resource "aws_vpc" "vpc4eks" {  
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-eks-vpc"
  }
}