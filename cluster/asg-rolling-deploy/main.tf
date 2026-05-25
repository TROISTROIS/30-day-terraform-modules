resource "aws_security_group" "EC2_SG" {
    description = "Security group for the instances"
    vpc_id = var.vpc_id
    name = "${var.environment}-EC2-SG"
    tags = merge(local.common_tags, {
        Name = "${var.environment}-EC2-SG"
    }
    )
}

resource "aws_vpc_security_group_ingress_rule" "EC2_SG_ingress" {
    description = "EC2 Security Group rule allowing Inbound traffic from the Load Balancer"
    referenced_security_group_id = var.elb_sg_id
    from_port = local.Server_Port
    to_port = local.Server_Port
    ip_protocol = local.tcp_protocol
    security_group_id = aws_security_group.EC2_SG.id
    tags = merge(local.common_tags, {
        Name = "${var.environment}-EC2-Ingress"
    }
    )
}

resource "aws_vpc_security_group_egress_rule" "EC2_allow_all_outbound" {
    description = "EC2 security group rule to allow all outbound traffic"
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

    user_data = base64encode(var.user_data)

    lifecycle {
        create_before_destroy = true
        precondition {
          condition = data.aws_ec2_instance_type.instance.free_tier_eligible
          error_message = "${local.InstanceType} is not part of the AWS Free Tier"
        }
    }
}

resource "aws_autoscaling_group" "ASG" {
    name = "${var.environment}-ASG"
    max_size = var.maxServers
    min_size = var.minServers 
    vpc_zone_identifier = [var.subnet_ids[2], var.subnet_ids[3]]

    launch_template {
        id = aws_launch_template.AMI.id
        version = aws_launch_template.AMI.latest_version
    }
    target_group_arns = var.target_group_arns
    health_check_type = var.health_check_type
    health_check_grace_period = 300

    lifecycle {
        postcondition {
          condition = length(self.availability_zones) > 1
          error_message = "You must use more than 1 AZ for high availability"
        }
    }

    instance_refresh {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = 50
      }
    }

    tag {
        key = "Name"
        value = "${var.environment}-ASG" 
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

    scheduled_action_name = "${var.environment}-scale-out-during-business-hours"
    min_size = local.min_cluster_size
    max_size = local.max_cluster_size
    desired_capacity = 3
    recurrence = "30 12 * * *"
    autoscaling_group_name = aws_autoscaling_group.ASG.name
}

resource "aws_autoscaling_schedule" "scale-in-at-night" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "${var.environment}-scale-in-at-night" 
    min_size = local.min_cluster_size
    max_size = local.max_cluster_size
    desired_capacity = 1
    recurrence = "32 12 * * *"
    autoscaling_group_name = aws_autoscaling_group.ASG.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.environment}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ASG.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", local.InstanceType) == "t" ? 1 : 0

  alarm_name  = "${var.environment}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ASG.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}
