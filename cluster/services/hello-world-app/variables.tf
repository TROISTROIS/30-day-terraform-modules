variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["Stage", "Production", "Test"], var.environment)
        error_message = "Environment must be Stage or Production. "
    }
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

variable "VPC_CIDR" {
    description = "The VPC CIDR"
    type = string
}

variable "newbits" {
    description = "How many bits to add to the prefix"
    type = number
}

variable "subnet_count" {
    description = "The number of subnets"
    type = number
}

variable "AZs" {
    description = "The number of AZs"
    type = number
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
