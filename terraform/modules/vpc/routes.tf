resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgtw.id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "private-zone1-rt-association" {
  subnet_id      = aws_subnet.private-zone1-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-zone2-rt-association" {
  subnet_id      = aws_subnet.private-zone2-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "public-zone1-rt-association" {
  subnet_id      = aws_subnet.public-zone1-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-zone2-rt-association" {
  subnet_id      = aws_subnet.public-zone1-subnet.id
  route_table_id = aws_route_table.public-rt.id
}