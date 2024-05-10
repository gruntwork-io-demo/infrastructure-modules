# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed in by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_name" {
  description = "The name of the VPC to use for testing"
  type        = string
}

#---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These values may optionally be overwritten by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  description = "The name to use for all resources created by this module, including the ECS service, ECS cluster, ALB, and so on."
  type        = string
  default     = "example-service"
}

variable "text" {
  description = "The text to pass into the PROVIDER environment variable so that the server responds with 'Hello, <text>!'"
  type        = string
  default     = "from ECS Fargate"
}