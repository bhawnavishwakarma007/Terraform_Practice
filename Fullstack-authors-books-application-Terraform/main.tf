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
    Name = var.lb_public_1_name
  }
}

#Creating public subnets for frontend load balancer
resource "aws_subnet" "LB_public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.LB_subnet-2_cidr_block
  availability_zone       = var.subnet-1b_az # us-east-1b
  map_public_ip_on_launch = true
  tags = {
    Name = var.lb_public_2_name
  }
}

#Creating private subnets for frontend servers
resource "aws_subnet" "Fprivate-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Fsubnet-3_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1a
  tags = {
    Name = var.frontend_private_3_name
  }
}
#Creating private subnets for frontend servers
resource "aws_subnet" "Fprivate-4" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Fsubnet-4_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1b
  tags = {
    Name = var.frontend_private_4_name
  }
}

#Creating private subnets for backend servers
resource "aws_subnet" "Bprivate-5" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Bsubnet-5_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1c
  tags = {
    Name = var.backend_private_5_name
  }
}

#Creating private subnets for backend servers
resource "aws_subnet" "Bprivate-6" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Bsubnet-6_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1c
  tags = {
    Name = var.backend_private_6_name
  }
}

#Creating private subnets for RDS
resource "aws_subnet" "RDS_private-7" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.RDS_subnet-7_cidr_block
  availability_zone = var.subnet-1a_az # us-east-1a
  tags = {
    Name = var.rds_private_7_name
  }
}

#Creating private subnets for RDS
resource "aws_subnet" "RDS_private-8" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.RDS_subnet-8_cidr_block
  availability_zone = var.subnet-1b_az # us-east-1b
  tags = {
    Name = var.rds_private_8_name
  }
}

#Creating internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}

#Creating Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.public_route_table_name
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
    Name = var.eip_name
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "nat" {
  subnet_id         = aws_subnet.LB_public-1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.eip.id
  tags = {
    Name = var.nat_gateway_name
  }
}

#Creating Private Route Table
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.private_route_table_name
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
  subnet_id      = aws_subnet.Bprivate-5.id
}

#Creating Private Route Table Association for RSD Subnet6
resource "aws_route_table_association" "pvt-6" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id      = aws_subnet.Bprivate-6.id
}

#Creating Private Route Table Association for RSD Subnet7
resource "aws_route_table_association" "pvt-7" {
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
  name        = var.bastion_host_sg_name
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
    Name = var.bastion_host_sg_name
  }
}

#Creating Security Group for ALB Frontend
resource "aws_security_group" "alb-frontend-sg" {
  name        = var.alb_frontend_sg_name
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
    Name = var.alb_frontend_sg_name
  }
}

#  Creating Security Group for ALB Backend
resource "aws_security_group" "alb-backend-sg" {
  name        = var.alb_backend_sg_name
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
    Name = var.alb_backend_sg_name
  }
}

# Creating Security Group for Frontend Server
resource "aws_security_group" "frontend-server-sg" {
  name        = var.frontend_server_sg_name
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
    Name = var.frontend_server_sg_name
  }
}

#  Creating security group for backend server
resource "aws_security_group" "backend-server-sg" {
  name        = var.backend_server_sg_name
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
    Name = var.backend_server_sg_name
  }
}

# Creating security group for RDS database 
resource "aws_security_group" "book-rds-sg" {
  name        = var.rds_sg_name
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
    Name = var.rds_sg_name
  }
}

##############################################################################################

#Creating EC2 Instances for frontend server
resource "aws_instance" "frontend-server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.frontend-server-sg.id]
  subnet_id              = aws_subnet.Fprivate-3.id
  #TODO: Add user data to the frontend server
  tags = {
    Name = var.frontend_instance_name
  }
}

#Creating EC2 Instances for backend server
resource "aws_instance" "backend-server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend-server-sg.id]
  subnet_id              = aws_subnet.Bprivate-5.id

  #TODO: Add user data to the backend server
  tags = {
    Name = var.backend_instance_name
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
    Name = var.rds_subnet_group_tag_name
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

#Cretaing AMI for frontend server
resource "aws_ami_from_instance" "frontend-ami" {
  name                    = var.frontend_ami_name
  source_instance_id      = aws_instance.frontend-server.id
  depends_on              = [aws_instance.frontend-server]
  snapshot_without_reboot = false
  tags = {
    Name = var.frontend_ami_name
  }
}

#Cretaing AMI for backend server
resource "aws_ami_from_instance" "backend-ami" {
  name                    = var.backend_ami_name
  source_instance_id      = aws_instance.backend-server.id
  depends_on              = [aws_instance.backend-server]
  snapshot_without_reboot = false
  tags = {
    Name = var.backend_ami_name
  }
}

#Launch Template Resource for frontend server
resource "aws_launch_template" "frontend" {
  name                   = var.frontend_launch_template_name
  description            = var.frontend_launch_template_description
  image_id               = aws_ami_from_instance.frontend-ami.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.frontend-server-sg.id]
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.frontend_instance_name
    }
  }
}

#Launch Template Resource for backend server
resource "aws_launch_template" "backend" {
  name                   = var.backend_launch_template_name
  description            = var.backend_launch_template_description
  image_id               = aws_ami_from_instance.backend-ami.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend-server-sg.id]
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.backend_instance_name
    }
  }
}

##############################################################################################

#Creating Target Group for frontend server
resource "aws_lb_target_group" "frontend-tg" {
  name     = var.frontend_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

#creating Load Balancer for frontend server
resource "aws_lb" "frontend-lb" {
  name               = var.frontend_lb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_subnet.LB_public-1.id, aws_subnet.LB_public-2.id]
  tags = {
    Name = var.frontend_lb_name
  }
  depends_on = [aws_lb_target_group.frontend-tg]
}

#Creating Listener for frontend server
resource "aws_lb_listener" "frontend-listener" {
  load_balancer_arn = aws_lb.frontend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
  depends_on = [aws_lb.frontend-lb, aws_lb_target_group.frontend-tg]
}

#Creating Target Group for backend server
resource "aws_lb_target_group" "backend-tg" {
  name     = var.backend_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

#creating Load Balancer for backend server
resource "aws_lb" "backend-lb" {
  name               = var.backend_lb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_subnet.LB_public-1.id, aws_subnet.LB_public-2.id]
  tags = {
    Name = var.backend_lb_name
  }
  depends_on = [aws_lb_target_group.backend-tg]
}

#Creating Listener for backend server
resource "aws_lb_listener" "backend-listener" {
  load_balancer_arn = aws_lb.backend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }
  depends_on = [aws_lb.backend-lb, aws_lb_target_group.backend-tg]
}

##############################################################################################

#Creating Auto Scaling Group for frontend server
resource "aws_autoscaling_group" "frontend-asg" {
  name              = var.frontend_asg_name
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  target_group_arns = [aws_lb_target_group.frontend-tg.arn]
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.Fprivate-3.id, aws_subnet.Fprivate-4.id]

  depends_on = [aws_launch_template.frontend]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }

  tag {
    key                 = "Name"
    value               = var.frontend_asg_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "frontend-scale-out" {
  name                   = var.frontend_scale_out_policy_name
  autoscaling_group_name = aws_autoscaling_group.frontend-asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.scale_out_target_value
  }
}

#Creating Auto Scaling Group for backend server
resource "aws_autoscaling_group" "backend-asg" {
  name              = var.backend_asg_name
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  target_group_arns = [aws_lb_target_group.backend-tg.arn]
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.Bprivate-3.id, aws_subnet.Bprivate-4.id]

  depends_on = [aws_launch_template.backend]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }

  tag {
    key                 = "Name"
    value               = var.backend_asg_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "backend-scale-out" {
  name                   = var.backend_scale_out_policy_name
  autoscaling_group_name = aws_autoscaling_group.backend-asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.scale_out_target_value
  }
}