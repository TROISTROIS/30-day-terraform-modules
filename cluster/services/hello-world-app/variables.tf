variable "environment" {
    description = "Environment I am working on"
    type = string

    validation {
        condition = contains(["Stage", "Production"], var.Environment)
        error_message = "Environment must be Stage or Production. "
    }
}

variable "elb_http_listener_arn" {
  description = "The ARN of the HTTP listener"
  type = string
}

variable "target_group_arn" {
    description = "The ARN of the target group"
    type = string
}