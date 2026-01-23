# Example-1
# resource "aws_s3_bucket" "name" {
#   bucket = "how-to-train-ur-dragon"
# }
# resource "null_resource" "name" {
#   depends_on = [ aws_s3_bucket.name ]
#   provisioner "local-exec" {
#   command = "aws s3 cp file.txt s3://${aws_s3_bucket.name.bucket}/file.txt" 
#    }
# }

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.0.0/24"
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

resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}


resource "aws_key_pair" "name" {
  key_name   = "key-pair"
  public_key = file("~/.ssh/key-pair.pub")
}


resource "aws_instance" "name" {
  ami                    = "ami-068c0051b15cdb816"
  vpc_security_group_ids = [aws_security_group.name.id]
  iam_instance_profile = aws_iam_instance_profile.profile.name
  instance_type          = "t2.medium"
  subnet_id = aws_subnet.name.id
  key_name               = aws_key_pair.name.key_name
  tags = {
    Name = "test"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "how-to-train-ur-dragon"
}



resource "null_resource" "name" {
  depends_on = [aws_s3_bucket.name]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/key-pair")
    host        = aws_instance.name.public_ip
  }

  provisioner "file" {
  source      = "file.txt"
  destination = "/home/ec2-user/file.txt"
}

provisioner "remote-exec" {
  inline = [
    "aws s3 cp /home/ec2-user/file.txt s3://${aws_s3_bucket.name.bucket}/file.txt"
  ]
}

}
