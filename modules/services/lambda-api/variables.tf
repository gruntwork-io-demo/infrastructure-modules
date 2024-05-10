# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed in by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  description = "The name to use for all resources created by this module, including the Lambda function, API Gateway, etc."
  type        = string
}

variable "source_path" {
  description = "The path to the directory that contains your Lambda function source code. This code will be zipped up and uploaded to Lambda as your deployment package."
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function (e.g. nodejs, python3.9, java8). See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime for all possible values."
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code. This is typically the name of a function or method in your code that AWS will execute when this Lambda function is triggered."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "timeout" {
  description = "The maximum amount of time, in seconds, your Lambda function will be allowed to run. Must be between 1 and 300 seconds."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "The maximum amount of memory, in MB, your Lambda function will be able to use at runtime. Can be set in 64MB increments from 128MB up to 1536MB. Note that the amount of CPU power given to a Lambda function is proportional to the amount of memory you request, so a Lambda function with 256MB of memory has twice as much CPU power as one with 128MB."
  type        = number
  default     = 128
}

variable "function_description" {
  description = "A description of what the Lambda function does."
  type        = string
  default     = null
}

variable "api_description" {
  description = "A description of what the Lambda function does."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "A map of environment variables to pass to the Lambda function. AWS will automatically encrypt these with KMS and decrypt them when running the function."
  type        = map(string)

  # Lambda does not permit you to pass it an empty map of environment variables, so our default value has to contain
  # this totally useless placeholder.
  default = {
    EnvVarPlaceHolder = "Placeholder"
  }
}

variable "enable_versioning" {
  description = "Set to true to enable versioning for this Lambda function. This allows you to use aliases to refer to execute different versions of the function in different environments. Note that an alternative way to run Lambda functions in multiple environments is to version your Terraform code."
  type        = bool
  default     = false
}

variable "iam_role_tags" {
  description = "A map of tags to apply to the IAM role created for the lambda function. This will be merged with the var.tags parameter. Only used if var.existing_role_arn is null."
  type        = map(string)
  default     = {}
}

variable "function_tags" {
  description = "A map of tags to apply to the Lambda function and all resources created in the Lambda function module."
  type        = map(string)
  default     = {}
}

variable "api_tags" {
  description = "A map of tags to assign to the API."
  type        = map(string)
  default     = {}
}

variable "stage_tags" {
  description = "A map of tags to assign to the API Gateway stage."
  type        = map(string)
  default     = {}
}

variable "lambda_role_permissions_boundary_arn" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role for the lambda"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "A custom assume role policy for the IAM role for this Lambda function. If not set, the default is a policy that allows the Lambda service to assume the IAM role, which is what most users will need. However, you can use this variable to override the policy for special cases, such as using a Lambda function to rotate AWS Secrets Manager secrets."
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "The name to use for the IAM role created for the lambda function. If null, default to the function name (var.name). Only used if var.existing_role_arn is null."
  type        = string
  default     = null
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function or -1 if unreserved."
  type        = number
  default     = null
}

variable "architecture" {
  description = "Instruction set architecture for your Lambda function. Valid values are: x86_64; arm64. When null, defaults to x86_64."
  type        = string
  default     = null
}

variable "ephemeral_storage" {
  description = "The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB. This parameter is used to expand the total amount of Ephemeral storage available, beyond the default amount of 512MB."
  type        = number
  default     = null
}

variable "create_route53_entry" {
  description = "Set to true if you want a DNS record automatically created and pointed at the API Gateway endpoint."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name to create a route 53 record for. This DNS record will point to the API Gateway endpoint."
  type        = string
  default     = null
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone into which the Route 53 DNS record should be written."
  type        = string
  default     = null
}

variable "certificate_domain" {
  description = "The domain to use when looking up the ACM certificate. This is useful for looking up wild card certificates that will match the given domain name. When null (default), var.domain_name will be used to look up the certificate."
  type        = string
  default     = null
}
