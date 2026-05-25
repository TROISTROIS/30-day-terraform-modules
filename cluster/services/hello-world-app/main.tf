module "asg" {
  source = "../../../cluster/asg-rolling-deploy"

  vpc_id = module.vpc.vpc_id
  environment = var.environment
  elb_sg_id = module.elb.elb_sg_id
  ami = var.ami
  day = var.day
  minServers = var.minServers
  maxServers = var.maxServers
  subnet_ids = module.vpc.subnet_ids
  target_group_arns = [aws_lb_target_group.LBTargetGroup.arn]
  custom_tags = var.custom_tags
  enable_autoscaling = var.enable_autoscaling
  health_check_type = "ELB"
  user_data = templatefile("${path.module}/user-data.sh", {
      server_port = local.Server_Port
      environment = var.environment
      server_text = var.server_text
      day = var.day
  })
}

module "elb" {
  source = "../../../cluster/networking/alb" 
  
  vpc_id = module.vpc.vpc_id
  environment = var.environment
  subnet_ids = module.vpc.subnet_ids
  ec2_sg_id = module.asg.ec2_sg_id
}

module "vpc" {
  source = "../../../cluster/networking/vpc" 

  VPC_CIDR = var.VPC_CIDR
  environment = var.environment
  newbits = var.newbits
  subnet_count = var.subnet_count
  AZs = var.AZs
  day = var.day
}

resource "aws_lb_target_group" "LBTargetGroup" {
    name = "${var.environment}-LBTargetGroup"
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
    tags = merge(local.common_tags, {
        Name = "${var.environment}-LBTargetGroup"
    })
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