##############################################################################################
# VPC
##############################################################################################

variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

##############################################################################################
# Subnets
##############################################################################################

# Availability Zones
variable "subnet-1a_az" {
  type    = string
  default = ""
}
variable "subnet-1b_az" {
  type    = string
  default = ""
}

# Public LB Subnets
variable "LB_subnet-1_cidr_block" {
  type    = string
  default = ""
}
variable "lb_public_1_name" {
  type    = string
  default = ""
}

variable "LB_subnet-2_cidr_block" {
  type    = string
  default = ""
}
variable "lb_public_2_name" {
  type    = string
  default = ""
}

# Frontend Private Subnets
variable "Fsubnet-3_cidr_block" {
  type    = string
  default = ""
}
variable "frontend_private_3_name" {
  type    = string
  default = ""
}

variable "Fsubnet-4_cidr_block" {
  type    = string
  default = ""
}
variable "frontend_private_4_name" {
  type    = string
  default = ""
}

# Backend Private Subnets
variable "Bsubnet-5_cidr_block" {
  type    = string
  default = ""
}
variable "backend_private_5_name" {
  type    = string
  default = ""
}

variable "Bsubnet-6_cidr_block" {
  type    = string
  default = ""
}
variable "backend_private_6_name" {
  type    = string
  default = ""
}

# RDS Private Subnets
variable "RDS_subnet-7_cidr_block" {
  type    = string
  default = ""
}
variable "rds_private_7_name" {
  type    = string
  default = ""
}

variable "RDS_subnet-8_cidr_block" {
  type    = string
  default = ""
}
variable "rds_private_8_name" {
  type    = string
  default = ""
}

##############################################################################################
# Internet Gateway / NAT / Route Tables
##############################################################################################

variable "internet_gateway_name" {
  type    = string
  default = ""
}

variable "public_route_table_name" {
  type    = string
  default = ""
}

variable "private_route_table_name" {
  type    = string
  default = ""
}

variable "eip_name" {
  type    = string
  default = ""
}

variable "nat_gateway_name" {
  type    = string
  default = ""
}

##############################################################################################
# Security Groups
##############################################################################################

variable "bastion_host_sg_name" {
  type    = string
  default = ""
}

variable "alb_frontend_sg_name" {
  type    = string
  default = ""
}

variable "alb_backend_sg_name" {
  type    = string
  default = ""
}

variable "frontend_server_sg_name" {
  type    = string
  default = ""
}

variable "backend_server_sg_name" {
  type    = string
  default = ""
}

variable "rds_sg_name" {
  type    = string
  default = ""
}

##############################################################################################
# EC2 Instances
##############################################################################################

variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "key_name" {
  type    = string
  default = ""
}

variable "frontend_instance_name" {
  type    = string
  default = ""
}

variable "backend_instance_name" {
  type    = string
  default = ""
}

##############################################################################################
# AMIs
##############################################################################################

variable "frontend_ami_name" {
  type    = string
  default = ""
}

variable "backend_ami_name" {
  type    = string
  default = ""
}

##############################################################################################
# Launch Templates
##############################################################################################

variable "frontend_launch_template_name" {
  type    = string
  default = ""
}

variable "frontend_launch_template_description" {
  type    = string
  default = ""
}

variable "backend_launch_template_name" {
  type    = string
  default = ""
}

variable "backend_launch_template_description" {
  type    = string
  default = ""
}

##############################################################################################
# Load Balancers / Target Groups / Listeners
##############################################################################################

variable "vpc_id" {
  type    = string
  default = ""
}

variable "frontend_lb_name" {
  type    = string
  default = ""
}

variable "backend_lb_name" {
  type    = string
  default = ""
}

variable "frontend_tg_name" {
  type    = string
  default = ""
}

variable "backend_tg_name" {
  type    = string
  default = ""
}

variable "frontend_listener_name" {
  type    = string
  default = ""
}

variable "backend_listener_name" {
  type    = string
  default = ""
}

##############################################################################################
# Auto Scaling
##############################################################################################

variable "frontend_asg_name" {
  type    = string
  default = ""
}

variable "backend_asg_name" {
  type    = string
  default = ""
}

variable "frontend_scale_out_policy_name" {
  type    = string
  default = ""
}

variable "backend_scale_out_policy_name" {
  type    = string
  default = ""
}

variable "min_size" {
  type    = string
  default = "1"
}

variable "max_size" {
  type    = string
  default = "3"
}

variable "desired_capacity" {
  type    = string
  default = "1"
}

variable "scale_out_target_value" {
  description = "Target CPU utilization % for scaling"
  type        = number
  default     = 80
}

##############################################################################################
# RDS
##############################################################################################

variable "subnet_group_name" {
  type    = string
  default = ""
}

variable "rds_subnet_group_tag_name" {
  type    = string
  default = ""
}

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

##############################################################################################
# RDS IAM
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
