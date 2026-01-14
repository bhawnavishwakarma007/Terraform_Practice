resource "aws_security_group" "name" {
  name        = "multiple-sg-rules-diff-cidr"
  description = "Multiple SG rules with different CIDR blocks"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  egress {
    from_port= 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "multiple-sg-rules-diff-cidr"
  }
}
