resource "aws_ecs_cluster" "webapp-cluster" {
  name = "webapp_cluster"
}

resource "aws_ecr_repository" "webapp-repository" {
  name                 = "webapp-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_cloudwatch_log_group" "webapp_logs" {
  name              = "/ecs/web-app"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "webapp-task-definition" {
  family                   = "webapp"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs-execution-role.arn
  container_definitions = jsonencode([{
    name      = "webapp-container"
    image     = "${aws_ecr_repository.webapp-repository.repository_url}:f419407f8802f40dcd2c8654a9f5f0a1a7e724a5"
    essential = true
    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
      }
    ]
    environment = [
      {
        name  = "DB_HOST"
        value = aws_db_instance.postgre.address
      },
      {
        name  = "DB_PASSWORD"
        value = jsondecode(data.aws_secretsmanager_secret_version.dev-db-postgre-value.secret_string)["dev-db-postgre-pwd"]
      },
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/web-app"
        "awslogs-region"        = "eu-central-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "webapp-service" {
  name            = "webapp_service"
  cluster         = aws_ecs_cluster.webapp-cluster.id
  task_definition = aws_ecs_task_definition.webapp-task-definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
    security_groups  = [aws_security_group.webapp.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main_lb_target_group.arn
    container_name   = "webapp-container"
    container_port   = 8000
  }

}
