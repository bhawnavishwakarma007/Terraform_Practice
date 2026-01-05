#creation of vpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}

#creation of public subnet
resource "aws_subnet" "dev" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dev-public"
  }
}

#creation of private subnet
resource "aws_subnet" "test" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dev-private"
  }
}

#creation of internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-ig"
  }
}

#creation of public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}

#public route table association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.dev.id
  route_table_id = aws_route_table.public.id
}

#creation of elastic ip for nat gateway
resource "aws_eip" "name" {
  domain = "vpc"
  tags = {
    Name = "eip"
  }
}

#creation of nat gateway (always in public subnet)
resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.name.id
  subnet_id     = aws_subnet.dev.id
  tags = {
    Name = "nat-gateway"
  }
  depends_on = [aws_internet_gateway.name]
}

#creation of private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name.id
  }
}

#private route table association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.test.id
  route_table_id = aws_route_table.private.id
}

#creation of security group
resource "aws_security_group" "name" {
  name   = "allow"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "security_group"
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creation of ec2 instance in public subnet
resource "aws_instance" "name" {
  ami                    = "ami-068c0051b15cdb816"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev.id
  vpc_security_group_ids = [aws_security_group.name.id]
}
