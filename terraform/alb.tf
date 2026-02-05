resource "aws_alb" "main" {
  security_groups = [aws_security_group.lb.id]
  name            = "webapp-load-balancer"
  subnets         = [aws_subnet.public_zone1.id, aws_subnet.public_zone2.id]

  tags = {
    Name = "webapp-load-balancer"
  }
}

#TODO: 
# 1. ALB target group
# 2. ABL listener
