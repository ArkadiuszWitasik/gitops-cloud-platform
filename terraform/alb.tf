resource "aws_alb" "main" {
  security_groups = [aws_security_group.lb.id]
  name            = "webapp-load-balancer"
  subnets         = [aws_subnet.public_zone1.id, aws_subnet.public_zone2.id]

  tags = {
    Name = "webapp-load-balancer"
  }
}

resource "aws_alb_target_group" "main_lb_target_group" {
  name        = "main_lb_target_group"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/health-check"
  }

  tags = {
    Name = "main_lb_target_group"
  }
}

resource "aws_alb_listener" "webapp_alb_listener" {
  load_balancer_arn = aws_alb.main.id
  port              = 8000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main_lb_target_group.id
    type             = "forward"
  }

  tags = {
    Name = "webapp_alb_listener"
  }
}
