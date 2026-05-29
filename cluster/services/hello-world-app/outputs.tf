output "target_group_arn" {
  description = "The ARN of the target group"
  value = aws_lb_target_group.LBTargetGroup.arn
}

output "ELB_DNS" {
    description = "The Load Blancer DNS name"
    value = module.elb.ELB_DNS
}

output "ec2_sg_id" {
    description = "The ID of the EC2 instance's security group"
    value = module.asg.ec2_sg_id
}

output "asg_name" {
    description = "The name of the name of the auto-scaling group"
    value = module.asg.asg_name
}

output "state_bucket" {
    description = "The name of the S3 backend state bucket"
    value = module.backend.state-s3-bucket-name
}

output "state-dynamodb-table" {
    description = "The name of the state dynamodb table"
    value = module.backend.state-dynamodb-table
}