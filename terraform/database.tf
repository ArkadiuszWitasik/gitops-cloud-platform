data "aws_secretsmanager_secret" "dev-db-postgre-meta" {
  name = "dev-db-postgre-pwd"
}

data "aws_secretsmanager_secret_version" "dev-db-postgre-value" {
  secret_id = data.aws_secretsmanager_secret.dev-db-postgre-meta.id
}

resource "aws_db_subnet_group" "postgre" {
  name       = "dev-db"
  subnet_ids = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]

  tags = {
    Name = "dev-db"
  }
}

resource "aws_db_instance" "postgre" {
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "11"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = jsondecode(data.aws_secretsmanager_secret_version.dev-db-postgre-value.secret_string)["dev-db-postgre-pwd"]
  db_subnet_group_name   = aws_db_subnet_group.postgre.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database.id]
}
