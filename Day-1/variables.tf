variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = ""
}
