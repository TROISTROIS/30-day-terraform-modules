# Hello World App (Service)

Service module that provisions a simple web application (EC2 instances/user-data, etc.).

## Usage

Example (typical usage):

```hcl
module "hello_world" {
  source = "../../cluster/services/hello-world-app"

  environment = "Test"
  ami = "ami-0ec10929233384c7f"
  server_text = "Test. Hello World from Testing"
  day = 16
  minServers = 2
  maxServers = 3
  VPC_CIDR = "10.0.0.0/16"
  newbits = 8
  subnet_count = 4
  AZs = 2
  custom_tags = {}
  enable_autoscaling = false
  health_check_type = "EC2"
  user_data = null
}
```

## Inputs
- `environment` (string) - Environment (Stage, Production, Test)
- `ami` (string) - AMI to use
- `server_text` (string) - Text served by the webserver
- `day` (string) - Challenge day
- `minServers` (number) - Minimum ASG size
- `maxServers` (number) - Maximum ASG size
- `VPC_CIDR` (string) - VPC CIDR (if creating VPC as part of the service)
- `newbits` (number)
- `subnet_count` (number)
- `AZs` (number)
- `custom_tags` (map(string))
- `enable_autoscaling` (bool)
- `health_check_type` (string)
- `user_data` (string)

## Outputs
- Check `outputs.tf` for available outputs (varies by module internals)
