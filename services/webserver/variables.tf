variable "VPC_name" {
    description = "The Name of the VPC"
    type = string
}

variable "VPC_CIDR" {
    description = "The VPC CIDR"
    type = string
}

variable "Subnet1_CIDR" {
    description = "The Subnet1 CIDR"
    type = string
}

variable "Subnet2_CIDR" {
    description = "The Subnet2 CIDR"
    type = string
}

variable "Subnet3_CIDR" {
    description = "The Subnet3 CIDR"
    type = string
}

variable "Subnet4_CIDR" {
    description = "The Subnet4 CIDR"
    type = string
}

variable "EC2AMI" {
    description = "AMI for EC2 launch"
    type = string
}

variable "InstanceType" {
    description = "EC2 Instance Type"
    type = string
}

variable "minServers" {
    description = "Minimum number of servers"
    type = number
}

variable "maxServers" {
    description = "Maximum number of servers"
    type = number
}

variable "Environment" {
    description = "Environment I am working on"
    type = string
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