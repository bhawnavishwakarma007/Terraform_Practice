# variable "create_ec2" {
#   type = bool
#   default = true
# }

# resource "aws_instance" "name" {
#   count = var.create_ec2 ? 1 : 0
#    ami           = "ami-068c0051b15cdb816"
#    instance_type = "t2.micro"
# }


# variable "s3_bucket" {
#   type = string
#   default = "how-to-train-ur-dragon"
# }

# resource "aws_s3_bucket" "name" {
#   bucket = var.s3_bucket
#   count = var.s3_bucket == "how-to-train-ur-dragon" ? 1 : 0
# }

variable "s3_bucket" {
  type    = bool
  default = false
}

resource "aws_s3_bucket" "name" {
  bucket = "how-to-train-ur-dragon"
  count  = var.s3_bucket ? 1 : 0
}
