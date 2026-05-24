output "ELB_DNS" {
    description = "The Load Blancer DNS name"
    value = module.elb.ELB_DNS
}

output "asg_name" {
    description = "The name of the name of the auto-scaling group"
    value = module.asg.asg_name
}

output "ec2_sg_id" {
    description = "The ID of the EC2 instance's security group"
    value = module.asg.ec2_sg_id
}