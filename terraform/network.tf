resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "dev-main"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "dev-igw"
    }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_zone1.id

  tags = {
    Name = "dev-nat"
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/26"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "dev-public-eu-central-1a"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.64/26"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "dev-public-eu-central-1b"
  }
}

resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.128/26"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "dev-private-eu-central-1a"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.192/26"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "dev-private-eu-central-1b"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dev-public" 
  }
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "dev-private"
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id 
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}