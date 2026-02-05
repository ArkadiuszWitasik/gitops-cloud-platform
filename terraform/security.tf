resource "aws_security_group" "lb" {
  name   = "lb-security-group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-lb-security-group"
  }
}

resource "aws_security_group" "webapp" {
  name   = "webapp-security-group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-webapp-security-group"
  }
}

resource "aws_security_group" "database" {
  name   = "database-security-group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-database-security-group"
  }
}
