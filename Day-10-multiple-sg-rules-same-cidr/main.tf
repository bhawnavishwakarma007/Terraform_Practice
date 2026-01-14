resource "aws_security_group" "name" {
  name = "Security_Group"
  description = "Allow TCP and SSH"

  ingress = [
    for port in [22,80,443,8080,9000,8081,3000] : {
      description = "Allow TCP on port ${port}"
      from_port = port
      to_port = port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = true
    }
  ]

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
  tags = {
    Name = "Security_Group"
  }
}
