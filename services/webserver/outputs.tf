output "region" {
    description = "AWS region"
    value = data.aws_region.current.id
}

output "AZs" {
    description = "AZs in this region"
    value = tolist(data.aws_availability_zones.available.names)
}

output "LoadBalancerDNS" {
    description = "Load Balancer DNS"
    value = aws_lb.ELB.dns_name
}

output "ASG_name" {
    description = "The name of the Auto-Scaling Group"
    value = aws_autoscaling_group.ASG.name
}