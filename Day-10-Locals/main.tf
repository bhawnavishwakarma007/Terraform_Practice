locals {
  ami            = "ami-068c0051b15cdb816"
  instance_type  = "t2.medium"
  instance_typee = "t2.micro"
  Name           = "testttt"
}

resource "aws_instance" "name" {
  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = local.Name
  }
}

resource "aws_instance" "first" {
  ami           = local.ami
  instance_type = local.instance_typee
  tags = {
    Name = "dev"
  }
}
