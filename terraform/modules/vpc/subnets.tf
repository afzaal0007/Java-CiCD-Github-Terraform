resource "aws_subnet" "private-zone1-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv-subnet1-cidr
  availability_zone = var.zone1

  tags = {
    "Name"                                             = "${var.env}-private-${var.zone1}"
    "kubernetes.io/role/internal-elb"                  = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private-zone2-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv-subnet2-cidr
  availability_zone = var.zone2

  tags = {
    "Name"                                             = "${var.env}-private-${var.zone2}"
    "kubernetes.io/role/internal-elb"                  = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public-zone1-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub-subnet1-cidr
  availability_zone       = var.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                             = "${var.env}-public-${var.zone1}"
    "kubernetes.io/role/elb"                           = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public-zone2-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub-subnet2-cidr
  availability_zone       = var.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                             = "${var.env}-public-${var.zone2}"
    "kubernetes.io/role/elb"                           = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
}