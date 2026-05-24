output "ec2_sg_id" {
    description = "The ID of the EC2 instance's security group"
    value = aws_security_group.EC2_SG.id
}

output "asg_name" {
    description = "The name of the name of the auto-scaling group"
    value = aws_autoscaling_group.ASG.name
}