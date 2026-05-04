variable "VPC_name" {
    description = "The Name of the VPC"
    type = string
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
variable "EC2AMI" {
    description = "AMI for EC2 launch"
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