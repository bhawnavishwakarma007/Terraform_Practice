resource "aws_instance" "name" {
    ami="ami-068c0051b15cdb816"
    instance_type = "t2.medium" 
    tags = {
      Name = "testttt"
    }
}

resource "aws_instance" "first" {
    ami="ami-068c0051b15cdb816"
    instance_type = "t2.micro" 
    tags = {
      Name = "dev"
    }
}
