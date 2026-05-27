provider "aws" {
    region = "us-east-1"
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  vpc_id = module.vpc.vpc_id
  environment = "Test"
  elb_sg_id = module.elb.elb_sg_id
  ami = "ami-0ec10929233384c7f"
  day = 16
  minServers = 2
  maxServers = 3
  subnet_ids = module.vpc.subnet_ids
  target_group_arns = [aws_lb_target_group.LBTargetGroup.arn]
  custom_tags = { }
  enable_autoscaling = false
  health_check_type = "ELB"
  user_data = templatefile("${path.module}/user-data.sh", {
      server_port = local.Server_Port
      environment = "Test"
      server_text = "Test. Hello World from Testing"
      day = 16
  })
}

module "elb" {
  source = "../../cluster/networking/elb" 
  
  vpc_id = module.vpc.vpc_id
  environment = "Test"
  subnet_ids = module.vpc.subnet_ids
  ec2_sg_id = module.asg.ec2_sg_id
  day = 16
}

module "vpc" {
  source = "../../cluster/networking/vpc" 

  VPC_CIDR = "10.0.0.0/16"
  environment = "Test"
  newbits = 8
  subnet_count = 4
  AZs = 2
  day = 16
}

resource "aws_lb_target_group" "LBTargetGroup" {
    name = "Test-LBTargetGroup"
    port = local.Server_Port
    protocol = local.http_protocol
    vpc_id = module.vpc.vpc_id

    health_check {
        path = "/"
        protocol = local.http_protocol
        healthy_threshold   = 2
        unhealthy_threshold = 5
        timeout = 3
        interval = 15
        matcher = "200"
    }
    tags = {
        Name = "Test-LBTargetGroup"
        Environment = "Test"
        ManagedBy   = "Terraform"
    }
}

resource "aws_lb_listener_rule" "ELB_Listener_rule" {
    listener_arn = module.elb.elb_http_listener_arn
    priority = 100

    condition {
        path_pattern {
          values = ["*"]
        }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.LBTargetGroup.arn
    }
}