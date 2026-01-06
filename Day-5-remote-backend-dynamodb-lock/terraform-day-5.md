# Day-5: Terraform State Locking with DynamoDB

---

## Why State Locking Is Needed?

- When multiple users run Terraform at the same time:
  - State file can get **corrupted**
  - Resources may be created/updated incorrectly
- State locking ensures:
  - Only **one Terraform operation** runs at a time
  - Safe collaboration in teams

---

## Terraform Backend with DynamoDB Locking

Terraform uses:
- **S3** → to store `terraform.tfstate`
- **DynamoDB** → to manage state locking

---

## DynamoDB Table for Locking

### Purpose of DynamoDB Table
- Used only for **locking**
- Prevents parallel `terraform apply`
- Does NOT store infrastructure data

---

### DynamoDB Table Requirements
- Table name: any name (example: `terraform-lock-table`)
- Partition key:
  ```text
  LockID (String)

Example:
LockID  → terraform-state-lock


How State Locking Works (Simple Flow)

Terraform Apply
      |
      v
Check DynamoDB Lock
      |
      |-- Lock Available → Acquire Lock → Apply Changes
      |
      |-- Lock Exists → Wait / Fail


What Happens During terraform apply?

Terraform creates a lock entry in DynamoDB

Other users:

Cannot run apply

Will see a lock error

After apply:

Lock is automatically released


Important Rule (Backend Changes)

Whenever you change anything inside backend.tf, you MUST run:
terraform init -reconfigure


How to Apply This Concept (Real-Time)
Step-by-Step

1. Create S3 bucket for state file

2. Create DynamoDB table

3. Partition key: LockID (String)

4. Configure backend.tf

Run:
terraform init
terraform apply




About DMS (Database Migration Service) – Concept Only

DMS is used to migrate databases:

From one region to another

From one database engine to another

Example:

MySQL → Aurora

On-prem → AWS

➡️ DMS is not directly related to Terraform locking
➡️ Mentioned as a migration concept


Key Takeaways (Day-5)

-S3 stores Terraform state file
-DynamoDB provides state locking
-Partition key must be LockID
-Prevents concurrent Terraform runs
-Mandatory for production environments

---