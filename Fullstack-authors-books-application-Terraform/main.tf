#Creating vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#Creating public subnets for frontend load balancer
resource "aws_subnet" "LB_public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.LB_subnet-1_cidr_block
  availability_zone       = var.subnet-1a_az # us-east-1a
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1a"
  }
}

#Creating public subnets for frontend load balancer
resource "aws_subnet" "LB_public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.LB_subnet-2_cidr_block
  availability_zone       = var.subnet-1b_az # us-east-1b
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2b"
  }
}

#Creating private subnets for frontend servers
resource "aws_subnet" "Fprivate-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Fsubnet-3_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1a
  tags = {
    Name = "private-3a"
  }
}
#Creating private subnets for frontend servers
resource "aws_subnet" "Fprivate-4" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Fsubnet-4_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1b
  tags = {
    Name = "private-4b"
  }
}

#Creating private subnets for backend servers
resource "aws_subnet" "Bprivate-5" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Bsubnet-5_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1c
  tags = {
    Name = "private-5a"
  }
}

#Creating private subnets for backend servers
resource "aws_subnet" "Bprivate-6" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Bsubnet-6_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1c
  tags = {
    Name = "private-6b"
  }
}

#Creating private subnets for RDS
resource "aws_subnet" "RDS_private-7" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.RDS_subnet-7_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1a
  tags = {
    Name = "private-7a"
  }
}

#Creating private subnets for RDS
resource "aws_subnet" "RDS_private-8" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.RDS_subnet-8_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1b
  tags = {
    Name = "private-8b"
  }
}


#Creating internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "book-ig"
  }
}

#Creating Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "book-pub-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}

#Creating Public Route Table Association LB_public-1
resource "aws_route_table_association" "pub-1" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.LB_public-1.id
}

#Creating Public Route Table Association LB_public-2
resource "aws_route_table_association" "pub-2" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.LB_public-2.id
}

#Creating Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  tags = {
    Name = "book-eip"
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "nat" {
  subnet_id         = aws_subnet.LB_public-1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.eip.id
  tags = {
    Name = "book-nat"
  }
}


#Creating Private Route Table
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "book-private-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

#Creating Private Route Table Association
resource "aws_route_table_association" "pvt-3" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.Fprivate-3.id
}

#Creating Private Route Table Association
resource "aws_route_table_association" "pvt-4" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.Fprivate-4.id
}

#Creating Private Route Table Association for RSD Subnet5
resource "aws_route_table_association" "pvt-5" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.Bprivate-5
}

#Creating Private Route Table Association for RSD Subnet6
resource "aws_route_table_association" "pvt-6" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.Bprivate-6
}

#Creating Private Route Table Association for RSD Subnet7
resource "aws_route_table_association" "pvt-5" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.RDS_private-7.id
}

#Creating Private Route Table Association for RSD Subnet8
resource "aws_route_table_association" "pvt-8" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.RDS_private-8.id
}

##############################################################################################

#Creating Security Group for ALB
resource "aws_security_group" "bastion-host-alb-sg" {
  name        = "alb-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-alb-sg"
  }
}


#Creating Security Group for ALB Frontend
resource "aws_security_group" "alb-frontend-sg" {
  name        = "alb-frontend-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress = [

    for port in [22, 443] : {
      description = "Allow inbound traffic from Frontend ALB on port ${port}"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-frontend-sg"
  }
}


#  Creating Security Group for ALB Backend

resource "aws_security_group" "alb-backend-sg" {
  name        = "alb-backend-sg"
  description = "Allow inbound traffic ALB"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress = [
    for port in [80, 443] : {
      description = "Allow inbound traffic on port ${port}"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-backend-sg"
  }

}

# Creating Security Group for Frontend Server
resource "aws_security_group" "frontend-server-sg" {
  name        = "frontend-server-sg"
  description = "Allow inbound traffic "
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc, aws_security_group.alb-frontend-sg]

  ingress = [
    for port in [22, 80] : {
      description = "Allow inbound traffic on port ${port}"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-server-sg"
  }

}


#  Creating security group for backend server

resource "aws_security_group" "backend-server-sg" {
  name        = "backend-server-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc, aws_security_group.alb-backend-sg]

  ingress = [
    for port in [80, 22] : {
      description = "Allow inbound traffic on port ${port}"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-server-sg"
  }
}


# Creating security group for RDS database 
resource "aws_security_group" "book-rds-sg" {
  name        = "book-rds-sg"
  description = "Allow inbound "
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress = [
    for port in [3306] : {
      description = "mysql/aroura"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "book-rds-sg"
  }

}


##############################################################################################

#Creating RDS

#Creating RDS subnet group
resource "aws_db_subnet_group" "sub-grp" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.RDS_private-7.id, aws_subnet.RDS_private-8.id]
  depends_on = [aws_subnet.RDS_private-7, aws_subnet.RDS_private-8]
  tags = {
    Name = "RDS Subnet Group"
  }
}

#Creating IAM role for RDS
resource "aws_iam_role" "rds-iam" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "rds-iam-policy" {
  role       = aws_iam_role.rds-iam.name
  policy_arn = var.policy_arn
}

resource "aws_db_instance" "name" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  allocated_storage       = var.allocated_storage
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.name
  vpc_security_group_ids  = [aws_security_group.book-rds-sg.id]
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = aws_iam_role.rds-iam.arn
  maintenance_window      = var.maintenance_window
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  depends_on = [aws_db_subnet_group.sub-grp]
}


##############################################################################################

#Launch Template Resource



