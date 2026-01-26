variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "LB_subnet-1_cidr_block" {
  type    = string
  default = ""
}
variable "LB_subnet-2_cidr_block" {
  type    = string
  default = ""
}
variable "Fsubnet-3_cidr_block" {
  type    = string
  default = ""
}
variable "Fsubnet-4_cidr_block" {
  type    = string
  default = ""
}

variable "Bsubnet-5_cidr_block" {
  type    = string
  default = ""
}
variable "Bsubnet-6_cidr_block" {
  type    = string
  default = ""
}

variable "RDS_subnet-7_cidr_block" {
  type    = string
  default = ""
}
variable "RDS_subnet-8_cidr_block" {
  type    = string
  default = ""
}

variable "subnet-1a_az" {
  type    = string
  default = ""
}

variable "subnet-1b_az" {
  type    = string
  default = ""
}
##############################################################################################




variable "role_name" {
  type    = string
  default = ""
}

variable "assume_role_policy" {
  type    = string
  default = ""
}

variable "policy_arn" {
  type    = string
  default = ""
}

variable "subnet_group_name" {
  type    = string
  default = ""
}
# variable "subnet_ids" {
#   type = string
#   default = ""
# }

variable "identifier" {
  type    = string
  default = ""
}

variable "engine" {
  type    = string
  default = ""
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "instance_class" {
  type    = string
  default = ""
}

variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "allocated_storage" {
  type    = string
  default = ""
}

variable "backup_retention_period" {
  type    = string
  default = ""
}

variable "backup_window" {
  type    = string
  default = ""
}

variable "monitoring_interval" {
  type    = string
  default = ""
}

variable "maintenance_window" {
  type    = string
  default = ""
}

variable "deletion_protection" {
  type    = string
  default = ""
}

variable "skip_final_snapshot" {
  type    = string
  default = ""
}
