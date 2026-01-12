resource "aws_instance" "name" {
  ami               = "ami-07ff62358b87c7116"
  instance_type     = "t3.micro"
  availability_zone = "us-east-1c"
  tags = {
    Name = "import-ec2"
  }
}
