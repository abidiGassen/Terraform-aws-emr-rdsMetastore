resource "aws_db_instance" "benchmarks" {

  allocated_storage = "100"
  identifier = var.identifier
  instance_class = "db.m5.large"
  engine = "mysql"
  engine_version = "8.0.15"
  db_name = var.name
  storage_type = "gp2"
  username = var.username
  password = var.password
  port     = "3306"
  skip_final_snapshot = true
}