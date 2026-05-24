output "ELB_DNS" {
    description = "The Load Blancer DNS name"
    value = module.elb.ELB_DNS
}

output "elb_sg_id" {
  description = "The ID of the security group of the load balancer"
  value = module.elb.elb_sg_id
}

output "elb_http_listener_arn" {
  description = "The ARN of the ELB http listener"
  value = module.elb.elb_http_listener_arn
}