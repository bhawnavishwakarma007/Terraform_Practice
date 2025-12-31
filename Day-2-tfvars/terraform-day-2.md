# Day-2: Terraform tfvars & State File

---

## terraform.tfvars (Important Concept)

### Default Behavior
- Terraform automatically loads **terraform.tfvars**
- No need to mention it explicitly while running commands

---

### Using Custom tfvars File
If you change the tfvars file name (example: `dev.tfvars`),  
you must **explicitly mention it** during apply.

```bash
terraform apply -var-file="dev.tfvars"


Why Use Multiple tfvars Files?
-To manage multiple environments
dev.tfvars

test.tfvars

prod.tfvars

Same code, different values

Clean and scalable infrastructure

Key Point
If terraform.tfvars exists → Terraform picks it by default

Other files must be passed using -var-file

Terraform State File


What is terraform.tfstate?

terraform.tfstate is a state file

It maps:

Terraform configuration (code)
To real cloud resources (local / remote)

Purpose of State File
-Tracks real infrastructure
-Stores current state of resources
  -Maintains mapping between:
  -Resource name in code
  -Actual resource ID in cloud



What Does State File Do?
Tracks real-time changes


Compares:

-Desired state (code)
-Current state (cloud)


Decides what to:

-Create
-Update
-Delete



State File Comparison Logic

Terraform Code (Desired State)
          |
          v
terraform.tfstate
          |
          v
Cloud Infrastructure (Current State)
Terraform Apply – First Time vs Later
First terraform apply
Resources are created in cloud

State file is generated

State file stores current resource details

Subsequent terraform apply
Terraform refreshes state

Compares:

Code changes

Remote infrastructure changes

Applies only required updates



Terraform State Flow (Easy Diagram)

+------------------+
| Terraform Code   |
| (Desired State)  |
+------------------+
          |
          | terraform apply
          v
+------------------+
| terraform.tfstate|
+------------------+
          |
          | refresh & compare
          v
+------------------+
| Cloud Resources  |
| (Current State)  |
+------------------+


Key Takeaways (Day-2)
terraform.tfvars is loaded by default

Custom tfvars must be passed explicitly

terraform.tfstate tracks real infrastructure

State file compares desired vs current state

Terraform applies only required changes

Interview One-Liners
tfvars → separates values from code

state file → single source of truth

terraform apply → reconciliation engine


---

### 📁 Folder Structure
day-2/
├── provider.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── dev.tfvars
├── prod.tfvars
├── output.tf
├── terraform.tfstate
└── terraform-day-2.md



---
