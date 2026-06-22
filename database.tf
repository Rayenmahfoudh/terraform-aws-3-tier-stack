resource "aws_db_subnet_group" "rds" {
  name        = "patientping-private-subnet-group"
  description = "Private subnets for RDS DB instances"

  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "patientping-private-subnet-group"
  }

  depends_on = [aws_subnet.private_a, aws_subnet.private_b]
}

resource "aws_security_group" "patientping-rds-sg" {
  vpc_id = aws_vpc.main.id
  name   = "patientping-rds-sg"

  ingress {
    description     = "Allow app server to access DB"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.patientping-public.id]
  }

  tags = {
    Name = "patientping-rds-sg"
  }
}


resource "aws_db_instance" "main" {
  identifier     = "patientping-db"
  engine         = "postgres"
  engine_version = "17"
  instance_class = "db.t3.micro"

  username = var.db_username
  password = var.db_password

  allocated_storage = 20
  storage_type      = "gp2"

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.patientping-rds-sg.id]

  publicly_accessible = false
  availability_zone   = "us-east-1a"

  database_insights_mode       = "standard"
  performance_insights_enabled = false

  db_name                 = "patientping"
  backup_retention_period = 1


  tags = { Name = "patientping-db" }
}
