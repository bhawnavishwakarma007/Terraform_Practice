##################################
# Frontend EC2 Instance
##################################

resource "aws_instance" "frontend_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Install Apache, Python, Git
              yum install -y httpd python3 python3-pip git

              # Start Apache
              systemctl start httpd
              systemctl enable httpd

              # Clone Paytm frontend
              cd /opt
              git clone https://github.com/CloudTechDevOps/Paytm-fullstack-project.git

              # Copy frontend web files
              cp -r Paytm-fullstack-project/Frontend/Frontend-code/* /var/www/html/
              chmod -R 755 /var/www/html/

              # Setup S3 backend service
              cd Paytm-fullstack-project/Frontend/Frontend-S3
              pip3 install -r requirements.txt

              # Start frontend S3 backend service
              nohup python3 backends3.py > /var/log/frontend-s3.log 2>&1 &
              EOF

  tags = {
    Name = var.frontend_instance_name
  }
}
