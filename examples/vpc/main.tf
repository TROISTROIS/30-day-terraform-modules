provider "aws" {
    region = "us-east-1"
}

module "vpc" {
    source = "../../cluster/networking/vpc"

    VPC_CIDR = "10.0.0.0/16"
    environment = "Test"
    newbits = 8
    subnet_count = 4
    AZs = 2
}