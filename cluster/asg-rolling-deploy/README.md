# ASG Rolling Deploy

Module to create an Auto Scaling Group (ASG) with rolling deploy behavior and related resources.

## Usage

Example (from `modules/examples/asg/main.tf`):

```hcl
module "asg" {
    source = "../../cluster/asg-rolling-deploy"

    vpc_id = data.aws_vpc.default.id
    environment = "Test"
    elb_sg_id = aws_security_group.ELB_SG.id
    ami = "ami-0ec10929233384c7f"
    day = 16
    minServers = 1
    maxServers = 2
    subnet_ids = data.aws_subnets.default.ids
    target_group_arns = [ ]
    custom_tags = { }
    enable_autoscaling = false
    health_check_type = "EC2"
    user_data = templatefile("${path.module}/user-data.sh", {
        server_port = 8080
        environment = "Test"
        server_text = "Hello Test World !!"
        day = 16
  })
  
}
```

## Inputs
- `vpc_id` (string) - The ID of the VPC
- `environment` (string) - Environment (Stage, Production, Test)
- `elb_sg_id` (string) - ELB security group ID
- `ami` (string) - AMI to use (default set)
- `server_text` (string) - Text served by the webserver
- `day` (string) - Challenge day
- `minServers` (number) - Minimum ASG size
- `maxServers` (number) - Maximum ASG size
- `subnet_ids` (list(string)) - Subnet IDs for ELB/ASG
- `target_group_arns` (list(string)) - Target group ARNs (default [])
- `custom_tags` (map(string)) - Custom tags (default {})
- `enable_autoscaling` (bool) - Enable autoscaling
- `health_check_type` (string) - Health check type (default "EC2")
- `user_data` (string) - User-data script

## Outputs
- `ec2_sg_id` - ID of the EC2 instances' security group
- `asg_name` - Name of the Auto Scaling Group
