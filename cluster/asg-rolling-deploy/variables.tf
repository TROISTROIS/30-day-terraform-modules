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

variable "elb_sg_id" {
    description = "The ID of the security group of the load balancer"
    type = string
}

variable "ami" {
    description = "The AMI of the EC2 instances to launch"
    type = string
    default = "ami-0ec10929233384c7f"
}

variable "server_text" {
    description = "The text the web server should return"
    type = string
    default = "Hello World from Terraform !!"
}

variable "day" {
    description = "The day of the challenge"
    type = string
}

variable "minServers" {
    description = "Minimum number of servers that the ASG spins up"
    type = number
}

variable "maxServers" {
    description = "Maximum number of servers that the ASG spins up"
    type = number
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids from the VPC module for the ELB and the ASG"
}

variable "target_group_arns" {
    description = "The ARNs of the ELB target groups to register the instances"
    type = list(string)
    default = []
}

variable custom_tags {
    description = "Custom tags to set on the instances in the ASG"
    type = map(string)
    default = {}
}

variable "enable_autoscaling" {
    description = "If set to true, enable autoscaling"
    type = bool
}

variable "health_check_type" {
    description = "The type of health check to perform"
    type = string
    default = "EC2"
}

variable "user_data" {
    description = "The use data script to run in each instance during boot"
    type = string
    default = null
}