output "ELB_DNS" {
    description = "The Load Blancer DNS name"
    value = aws_lb.ELB.dns_name
}

output "elb_sg_id" {
  description = "The ID of the security group of the load balancer"
  value = aws_security_group.ELB_SG.id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value = aws_lb_target_group.LBTargetGroup.arn
}