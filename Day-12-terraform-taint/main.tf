resource "aws_instance" "name" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Taint"
  }
}

# resource "aws_s3_bucket" "name" {
#   bucket = "how-to-train-ur-dragon"
# }

#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.name
# terraform apply
