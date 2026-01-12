resource "aws_instance" "name" {
  ami           = "ami-068c0051b15cdb816b"
  instance_type = "t2.medium"
  tags = {
    Name = "Dev"
  }
  lifecycle {
    #prevent_destroy = true # Prevents Terraform from deleting the resource (safety protection)
    #ignore_changes        = [tags, instance_type] # Terraform will ignore tag changes made outside Terraform
    create_before_destroy = true   # Creates a new resource first, then deletes the old one (zero downtime)
  }

}
