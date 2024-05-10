#---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These values may optionally be overwritten by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  description = "The name to use for all resources created by this module, including the Lambda function, API Gateway, etc."
  type        = string
  default     = "example-service"
}

variable "source_path" {
  description = "The path to the directory that contains your Lambda function source code. This code will be zipped up and uploaded to Lambda as your deployment package."
  type        = string
  default     = "./src"
}

variable "runtime" {
  description = "The runtime environment for the Lambda function (e.g. nodejs, python3.9, java8). See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime for all possible values."
  type        = string
  default     = "nodejs20.x"
}

variable "handler" {
  description = "The function entrypoint in your code. This is typically the name of a function or method in your code that AWS will execute when this Lambda function is triggered."
  type        = string
  default     = "index.handler"
}

variable "architecture" {
  description = "Instruction set architecture for your Lambda function. Valid values are: x86_64; arm64. When null, defaults to x86_64."
  type        = string
  default     = "arm64"
}
