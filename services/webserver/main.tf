resource "aws_vpc" "VPC" {
    cidr_block = var.VPC_CIDR
    tags = {
        Name = "${var.VPC_name}-VPC"
    }
}

resource "aws_subnet" "subnets" {
    for_each = local.subnets 
    availability_zone = data.aws_availability_zones.available.names[each.value.az_index]
    vpc_id = aws_vpc.VPC.id
    cidr_block = each.value.cidr
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.VPC_name}-${each.key}"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id
    tags = {
        Name = "${var.VPC_name}-IGW"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    vpc_id = aws_vpc.VPC.id
}

resource "aws_route" "Route" {
    route_table_id = aws_route_table.PublicRouteTable.id
    destination_cidr_block = local.IGW_destination_IP
    gateway_id = aws_internet_gateway.IGW.id
}

resource "aws_route_table_association" "public_associations" {
  for_each = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_security_group" "ELB_SG" {
    description = "ELB security group"
    name = "${var.VPC_name}-ELB_SG"
    vpc_id = aws_vpc.VPC.id
    tags = {
        Name = "${var.VPC_name}-ELB-SG"
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
        Name = "${var.VPC_name}-ELB-Ingress"
    }
}

resource "aws_vpc_security_group_egress_rule" "ELB_SG_egress" {
  security_group_id = aws_security_group.ELB_SG.id
  cidr_ipv4 = local.IGW_destination_IP
  ip_protocol = local.any_protocol
}

resource "aws_security_group" "EC2_SG" {
    description = "Security group for the instances"
    vpc_id = aws_vpc.VPC.id
    name = "${var.VPC_name}-EC2-SG"
    tags = {
        Name = "${var.VPC_name}-EC2-SG"
    }
}

resource "aws_vpc_security_group_ingress_rule" "EC2_SG_ingress" {
    description = "EC2 Security Group Ingress"
    referenced_security_group_id = aws_security_group.ELB_SG.id
    from_port = local.Server_Port
    to_port = local.Server_Port
    ip_protocol = local.tcp_protocol
    security_group_id = aws_security_group.EC2_SG.id
    tags = {
        Name = "${var.VPC_name}-EC2-Ingress"
    }
}

resource "aws_lb" "ELB" {
    subnets = [ values(aws_subnet.subnets)[0].id, values(aws_subnet.subnets)[1].id]
    security_groups = [aws_security_group.ELB_SG.id]
    name = "${var.VPC_name}-ELB"
    tags = {
        Name = "${var.VPC_name}-ELB"
    }
}

resource "aws_lb_target_group" "LBTargetGroup" {
    name = "${var.VPC_name}-LBTargetGroup"
    port = local.Server_Port
    protocol = local.http_protocol
    vpc_id = aws_vpc.VPC.id

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
        Name = "${var.VPC_name}-LBTargetGroup"
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

resource "aws_lb_listener_rule" "ELB_Listener_rule" {
    listener_arn = aws_lb_listener.ELB_Listener.arn
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

resource "aws_vpc_security_group_egress_rule" "ELB_to_EC2" {
  security_group_id = aws_security_group.ELB_SG.id
  referenced_security_group_id = aws_security_group.EC2_SG.id
  from_port = local.Server_Port
  to_port = local.Server_Port
  ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_egress_rule" "EC2_allow_all_outbound" {
  security_group_id = aws_security_group.EC2_SG.id
  cidr_ipv4 = local.IGW_destination_IP
  ip_protocol = local.any_protocol
}

resource "aws_launch_template" "AMI" {

    name_prefix = "AMI-"
    image_id = var.ami
    instance_type = local.InstanceType

    network_interfaces {
        associate_public_ip_address = true
        security_groups = [aws_security_group.EC2_SG.id]
    }

    user_data = base64encode(templatefile("${path.module}/user-data.sh", {
        server_port = local.Server_Port
        Environment = var.Environment
        server_text = var.server_text
        day = var.day
    }))

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ASG" {
    name = "${var.VPC_name}-ASG"
    max_size = var.maxServers
    min_size = var.minServers
    vpc_zone_identifier = [ values(aws_subnet.subnets)[2].id, values(aws_subnet.subnets)[3].id ]

    launch_template {
        id = aws_launch_template.AMI.id
        version = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.LBTargetGroup.arn]
    health_check_type = "ELB"
    health_check_grace_period = 300

    tag {
        key = "Name"
        value = "${var.VPC_name}-ASG"
        propagate_at_launch = true
    }

    dynamic "tag" {
        for_each = {
            for key, value in var.custom_tags:
            key => upper(value)
            if key != "Name"
        }
        
        content {
            key = tag.key
            value = tag.value
            propagate_at_launch = true
        }
}
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    count = var.enable_autoscaling ? 1 : 0

    scheduled_action_name = "${var.VPC_name}-scale-out-during-business-hours"
    min_size = local.min_cluster_size
    max_size = local.max_cluster_size
    desired_capacity = 3
    recurrence = "30 12 * * *"
    autoscaling_group_name = aws_autoscaling_group.ASG.name
}

resource "aws_autoscaling_schedule" "scale-in-at-night" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "${var.VPC_name}-scale-in-at-night" 
    min_size = local.min_cluster_size
    max_size = local.max_cluster_size
    desired_capacity = 1
    recurrence = "32 12 * * *"
    autoscaling_group_name = aws_autoscaling_group.ASG.name
}
