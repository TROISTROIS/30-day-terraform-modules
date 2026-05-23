variable "VPC_CIDR" {
    description = "The VPC CIDR"
    type = string
}

variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["Stage", "Production"], var.environment)
        error_message = "Environment must be Stage or Production. "
    }
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