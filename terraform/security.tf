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

resource "aws_security_group_rule" "lb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_egress_to_webapp" {
  type                     = "egress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webapp.id
  security_group_id        = aws_security_group.lb.id
}

resource "aws_security_group_rule" "webapp_ingress_from_lb" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.webapp.id
}

resource "aws_security_group_rule" "webapp_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webapp.id
}

resource "aws_security_group_rule" "db_ingress_from_webapp" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webapp.id
  security_group_id        = aws_security_group.database.id
}
