# Day-1: Terraform Variables & Lock File

## What is terraform.lock.hcl?
- `terraform.lock.hcl` is automatically created after running `terraform init`
- It locks the **provider versions**
- Prevents automatic provider upgrades in future runs
- Ensures **consistent infrastructure across environments**

### Upgrade Provider Version
```bash
terraform init --upgrade
➡️ This unlocks the provider version, upgrades it, and locks it again.



Terraform Variable Flow (Concept)
Terraform allows us to avoid hardcoding values by using variables.

Flow
terraform.tfvars  →  variables.tf  →  main.tf  →  Cloud


Architecture: Variable Passing Flow (Easy Diagram)

+-------------------+
| terraform.tfvars  |
|-------------------|
| ami_id = "ami-xxx"|
| type   = "t2.micro"
+-------------------+
          |
          | passes values
          v
+-------------------+
|  variables.tf     |
|-------------------|
| variable "ami_id" |
| variable "type"   |
+-------------------+
          |
          | referenced as var.*
          v
+-------------------+
|     main.tf       |
|-------------------|
| ami = var.ami_id  |
| instance_type     |
+-------------------+
          |
          | terraform apply
          v
+-------------------+
|   AWS Cloud       |
|  EC2 Instance     |
+-------------------+


terraform.tfvars
Used to store actual values

ami_id = "ami-068c0051b15cdb816"
type   = "t2.micro"


variables.tf
Used to declare variables

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "type" {
  description = "Instance type"
  type        = string
}


main.tf
Used to create resources

resource "aws_instance" "name" {
  ami           = var.ami_id
  instance_type = var.type
}


output.tf
Used to display important values after Terraform execution.

Why output.tf?
Shows resource details after creation

Helps in debugging

Can be reused by other Terraform modules

Useful for verification and automation

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.name.id
}

output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.name.public_ip
}
➡️ Outputs are displayed after running:
terraform apply


Why We Use Variables?
Avoid hardcoding

Easy environment change (dev / test / prod)

Clean and reusable code

Better security and readability



Day-1 Commands Used

terraform init
terraform plan
terraform apply
terraform destroy
Day-1 Key Takeaway
Terraform variables and outputs help us separate configuration, values,
and resource logic, making infrastructure reusable, scalable, and easy to manage.



📁 Folder Structure

day-1/
├── provider.tf
├── main.tf
├── variables.tf
├── output.tf
├── terraform.tfvars
├── terraform.lock.hcl
└── terraform-day-1.md

---

### ✅ Interview One-Liner
> **`output.tf` is used to display and reuse important infrastructure details after Terraform creates resources.**
