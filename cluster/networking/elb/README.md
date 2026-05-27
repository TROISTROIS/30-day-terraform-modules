# ELB (Load Balancer)

Module to create an AWS Application Load Balancer and related listeners/security groups.

## Usage

Example (from `modules/examples/elb/main.tf`):

```hcl
module "elb" {
    source = "../../cluster/networking/elb"

    vpc_id = data.aws_vpc.default.id
    environment = "Test"
    subnet_ids = data.aws_subnets.default.ids
    ec2_sg_id = aws_security_group.EC2_SG.id
    day = 16
}
```

## Inputs
- `vpc_id` (string) - The ID of the VPC
- `environment` (string) - Environment (Stage, Production, Test)
- `subnet_ids` (list(string)) - Subnet IDs for the ELB
- `ec2_sg_id` (string) - Security group ID for EC2 instances
- `day` (number) - Challenge day

## Outputs
- `ELB_DNS` - Load Balancer DNS name
- `elb_sg_id` - ELB security group ID
- `elb_http_listener_arn` - ARN of the ELB HTTP listener
