# VPC

Module to create a VPC and subnets.

## Usage

Example (from `modules/examples/vpc/main.tf`):

```hcl
module "vpc" {
    source = "../../cluster/networking/vpc"

    VPC_CIDR = "10.0.0.0/16"
    environment = "Test"
    newbits = 8
    subnet_count = 4
    AZs = 2
    day = 16
}
```

## Inputs
- `VPC_CIDR` (string) - VPC CIDR block
- `environment` (string) - Environment (Stage, Production, Test)
- `newbits` (number) - Bits to add to prefix
- `subnet_count` (number) - Number of subnets
- `AZs` (number) - Number of AZs
- `day` (number) - Challenge day

## Outputs
- `vpc_id` - Created VPC ID
- `subnet_ids` - List of subnet IDs
