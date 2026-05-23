variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
}

variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["Stage", "Production"], var.Environment)
        error_message = "Environment must be Stage or Production. "
    }
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids from the VPC module for the ELB and ASG"
}

variable "ec2_sg_id" {
    description = "The ID of the EC2 instance's security group"
    type = string
}