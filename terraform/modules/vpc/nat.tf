resource "aws_eip" "eip-nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-eip-nat"
  }
}

resource "aws_nat_gateway" "natgtw" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.public-zone1-subnet.id

  tags = {
    Name = "${var.env}-natgtw"
  }

  depends_on = [aws_internet_gateway.igw]
}