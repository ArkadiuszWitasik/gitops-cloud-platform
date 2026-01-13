resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    "Name" = "dev-main"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      "Name" = "dev-igw"
    }
}

resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/26"
  availability_zone = "eu-central-1a"

  tags = {
    "Name" = "dev-public-eu-central-1a"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.64/26"
  availability_zone = "eu-central-1b"

  tags = {
    "Name" = "dev-public-eu-central-1b"
  }
}

resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.128/26"
  availability_zone = "eu-central-1a"

  tags = {
    "Name" = "dev-private-eu-central-1a"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.192/26"
  availability_zone = "eu-central-1b"

  tags = {
    "Name" = "dev-private-eu-central-1b"
  }
}