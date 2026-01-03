# Day-3: Terraform State Behavior, Backup & Drift

---

## What Happens If terraform.tfstate Is Deleted?

- If the `terraform.tfstate` file is deleted:
  - Terraform **loses track** of existing infrastructure
  - Terraform treats resources as **new**
- When you run `terraform apply` again:
  - Terraform will **recreate the state file**
  - A **backup state file** is generated automatically
  - State is refreshed from the remote infrastructure

➡️ Terraform does **NOT** delete infrastructure automatically  
➡️ It only updates the **state file**

---

## Terraform State Backup

- Terraform creates a backup file:
  - `terraform.tfstate.backup`
- Backup contains the **previous known state**
- Helps recover from:
  - Accidental deletion
  - Corrupted state file

---

## Desired State vs Current State

- **Desired State**
  - What is written in Terraform code
  - Example: dev / test configuration

- **Current State**
  - What actually exists in cloud (AWS / Azure / GCP)

Terraform continuously compares:
Desired State (Code)
|
v
terraform.tfstate
|
v
Current State (Remote Cloud)


---

## First Time Resource Creation Behavior

- When you write a new resource for the first time:
  - Terraform plan shows:
    ```
    + 1 to add
    ```
- Resource does not exist yet
- After apply:
  - Resource is created
  - State file is updated

---

## Subsequent Changes Behavior

- If you modify an existing resource:
  - Terraform plan shows:
    ```
    ~ 1 to change
    ```
- Terraform updates only the modified part
- State file is refreshed after apply

---

## What If Someone Changes Resource in Remote (Manually)?

This situation is called **Infrastructure Drift**.

### What Terraform Does:
- During `terraform plan` or `terraform apply`:
  - Terraform refreshes state
  - Detects mismatch between:
    - State file
    - Remote infrastructure
- Terraform shows changes required to **bring infra back to desired state**

Example output:
~ 1 to change


➡️ Terraform does NOT ignore remote changes  
➡️ It always tries to match **code (desired state)**

---

## Terraform State Flow (Day-3 Diagram)

+-------------------+
| Terraform Code |
| (Desired State) |
+-------------------+
|
| terraform plan / apply
v
+-------------------+
| terraform.tfstate |
+-------------------+
|
| refresh & detect drift
v
+-------------------+
| Cloud Resources |
| (Current State) |
+-------------------+



---

## Key Takeaways (Day-3)

- State file deletion does not delete infrastructure
- Terraform auto-creates backup of state
- State file compares desired vs current state
- Terraform detects manual (remote) changes
- Terraform plan clearly shows:
  - `+` add
  - `~` change
  - `-` destroy

---

## Interview One-Liners

- **State deletion** → Terraform recreates state, not infra  
- **Drift** → difference between desired and current state  
- **Terraform plan** → preview of reconciliation  
- **terraform.tfstate.backup** → safety net
