data "aws_ec2_instance_type" "instance" {
    instance_type = local.InstanceType
}