resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "name" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "name" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "ig"
  }
}
# resource "aws_internet_gateway_attachment" "name" {
#   vpc_id         = aws_vpc.name.id
#   internet_gateway_id = aws_internet_gateway.name.id
# }

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}

resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

resource "aws_key_pair" "name" {
  key_name   = "key-pair"
  public_key = file("~/.ssh/key-pair.pub")
}


resource "aws_instance" "name" {
  ami                    = "ami-068c0051b15cdb816"
  vpc_security_group_ids = [aws_security_group.name.id]
  instance_type          = "t2.medium"
  subnet_id = aws_subnet.name.id
  key_name               = aws_key_pair.name.key_name
  tags = {
    Name = "test"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/key-pair")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "linux_practice.txt"
    destination = "/home/ec2-user/linux_practice.txt"
  }
}
