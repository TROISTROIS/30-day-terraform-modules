output "region" {
    description = "AWS region"
    value = data.aws_region.current.id
}

output "LoadBalancerDNS" {
    description = "Load Balancer DNS"
    value = aws_lb.ELB.dns_name
}

output "ASG_name" {
    description = "The name of the Auto-Scaling Group"
    value = aws_autoscaling_group.ASG.name
}

output "Autoscaling_Schedule_ARN" {
    description = "The ARN of the autoscaling schedule"
    value = var.enable_autoscaling ? aws_autoscaling_schedule.scale-in-at-night[0].arn : null
}