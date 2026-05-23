terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_security_group" "ELB_SG" {
    description = "ELB security group"
    name = "${var.environment}-ELB_SG"
    vpc_id = var.vpc_id
    tags = {
        Name        = "${var.environment}-ELB_SG"
        Environment = var.environment
        ManagedBy   = "Terraform"
    }
}

resource "aws_vpc_security_group_ingress_rule" "ELB_SG_ingress" {
    description = "ELB Security Group Ingress"
    cidr_ipv4 = local.IGW_destination_IP
    from_port = local.ELB_Port
    to_port = local.ELB_Port
    ip_protocol = local.tcp_protocol
    security_group_id = aws_security_group.ELB_SG.id
    tags = {
        Name = "${var.environment}-ELB-sg-ingress"
        Environment = var.environment
        ManagedBy   = "Terraform"
    }
}

resource "aws_vpc_security_group_egress_rule" "ELB_to_EC2" {
    description = "EC2 Security Group allowing outbound to the Load Balancer"
    security_group_id = aws_security_group.ELB_SG.id
    referenced_security_group_id = var.ec2_sg_id
    from_port = local.Server_Port
    to_port = local.Server_Port
    ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_egress_rule" "ELB_SG_egress" {
    security_group_id = aws_security_group.ELB_SG.id
    cidr_ipv4 = local.IGW_destination_IP
    ip_protocol = local.any_protocol
    tags = {
        Name = "${var.environment}-ELB-sg-egress"
        Environment = var.environment
        ManagedBy   = "Terraform"
    }
}

resource "aws_lb" "ELB" {
    subnets = [var.subnet_ids[0], var.subnet_ids[1]]
    security_groups = [aws_security_group.ELB_SG.id]
    name = "${var.environment}-ELB"
    tags = {
        Name = "${var.environment}-ELB"
        Environment = var.environment
        ManagedBy   = "Terraform"
    }
}

resource "aws_lb_listener" "ELB_Listener" {
  load_balancer_arn = aws_lb.ELB.arn
  port              = local.ELB_Port
  protocol          = local.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LBTargetGroup.arn
  }
}
