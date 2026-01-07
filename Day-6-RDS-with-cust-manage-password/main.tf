resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subnet"
  }
}

resource "aws_iam_role" "name" {
  name = "RDS-Instance-Role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": ["monitoring.rds.amazonaws.com"]
            },
            "Action": ["sts:AssumeRole"]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "name" {
 role = aws_iam_role.name.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "name" {
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  tags = {
    Name = "subnetgroup"
  }
}

resource "aws_db_instance" "name" {
  identifier = "my-db-instance"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro" #db.t3.micro is the smallest instance class
  username = "admin"
  password = "password"
  allocated_storage = 20
  db_subnet_group_name = aws_db_subnet_group.name.name
  parameter_group_name    = "default.mysql8.0"
   # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)
# Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.name.arn
    # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
}

resource "aws_db_instance" "replica" {
  identifier = "my-db-replica"
  instance_class = "db.t3.micro"
  engine = "mysql"
  replicate_source_db =  aws_db_instance.name.arn
  db_subnet_group_name = aws_db_subnet_group.name.name
}
