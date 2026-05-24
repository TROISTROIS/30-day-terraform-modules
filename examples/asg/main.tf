provider "aws" {
    region = "us-east-1"
}

module "asg" {
    source = "../../cluster/asg-rolling-deploy"

    vpc_id = data.aws_vpc.default.id
    environment = "Test"
    elb_sg_id = aws_security_group.ELB_SG.id
    ami = "ami-0ec10929233384c7f"
    day = 16
    minServers = 1
    maxServers = 2
    subnet_ids = data.aws_subnets.default.ids
    target_group_arns = [ ]
    custom_tags = { }
    enable_autoscaling = false
    health_check_type = "EC2"
    user_data = templatefile("${path.module}/user-data.sh", {
        server_port = 8080
        environment = "Test"
        server_text = "Hello Test World !!"
        day = 16
  })
  
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

resource "aws_security_group" "ELB_SG" {
    description = "ELB security group"
    name = "Test-ELB_SG"
    vpc_id = data.aws_vpc.default.id
    tags = {
        Name        = "Test-ELB_SG"
        Environment = "Test"
        ManagedBy   = "Terraform"
    }
}
