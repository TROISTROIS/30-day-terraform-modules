provider "aws" {
    region = "us-east-1"
}

module "elb" {
    source = "../../cluster/networking/elb"

    vpc_id = data.aws_vpc.default.id
    environment = "Test"
    subnet_ids = data.aws_subnets.default.ids
    ec2_sg_id = aws_security_group.EC2_SG.id
    day = 16
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}

resource "aws_security_group" "EC2_SG" {
    description = "Security group for the instances"
    vpc_id = data.aws_vpc.default.id
    name = "Test-EC2-SG"
    tags = {
        Name = "Test-EC2-SG"
        Environment = "Test"
        ManagedBy = "Terraform"
    }
}
