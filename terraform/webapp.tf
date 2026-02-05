resource "aws_ecr_repository" "webapp-repository" {
  name                 = "webapp-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}
