resource "aws_instance" "name" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-workspace"
  }
}



# Terraform Workspaces
# terraform workspace new	      Create a new workspace and select it
# terraform workspace select	  Select an existing workspace
# terraform workspace list	    List the existing workspaces
# terraform workspace show	    Show the name of the current workspace
# terraform workspace delete	  Delete an empty workspace
