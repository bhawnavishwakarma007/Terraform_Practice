# data "aws_vpc" "vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["vpc"]
#   }
# }
# resource "aws_subnet" "name" {
#   vpc_id            = data.aws_vpc.vpc.id #using data source's vpc id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "subnet"
#   }
# }

