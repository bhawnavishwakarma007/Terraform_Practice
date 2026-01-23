resource "aws_db_instance" "name" {
  identifier              = "my-db-instanceee"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "password"
  allocated_storage       = 20
  parameter_group_name    = "default.mysql8.0"
  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  deletion_protection     = true
  skip_final_snapshot     = true
}

resource "aws_db_instance" "replica" {
  identifier          = "my-db-replica"
  instance_class      = "db.t3.micro"
  engine              = "mysql"
  replicate_source_db = aws_db_instance.name.arn
}
