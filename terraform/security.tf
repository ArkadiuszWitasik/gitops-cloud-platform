resource "aws_security_group" "lb" {
  name = "lb-security-group"
  description = "Access to load balancer"
  vpc_id = aws_vpc.main.id

  ingress {
   protocol = "tcp"
   from_port = 8000
   to_port = 8000
   cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   protocol = "-1"
   from_port = 0
   to_port = 0
   cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name = "ecs-tasks-security-group"
  description = "Inbound access only from load balancer"
  vpc_id = aws_vpc.main.id

  ingress {
   protocol = "tcp"
   from_port = 8000
   to_port = 8000
   security_groups = [aws_security_group.lb.id]
  }

  egress {
   protocol = "-1"
   from_port = 0
   to_port = 0
   cidr_blocks = ["0.0.0.0/0"]
  }
}