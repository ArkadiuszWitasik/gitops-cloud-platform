resource "aws_ecr_repository" "webapp-repository" {
  name = "webapp-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecs_cluster" "webapp-cluster" {
  name = "dev-webapp-cluster"
}