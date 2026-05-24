output "ELB_DNS" {
    description = "The Load Blancer DNS name"
    value = aws_lb.ELB.dns_name
}

output "elb_sg_id" {
  description = "The ID of the security group of the load balancer"
  value = aws_security_group.ELB_SG.id
}

output "elb_http_listener_arn" {
  description = "The ARN of the ELB http listener"
  value = aws_lb_listener.ELB_Listener.arn
}