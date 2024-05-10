terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "lambda" {
  source = "git@github.com:gruntwork-io/terraform-aws-lambda.git//modules/lambda?ref=v0.21.16"

  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------

  name        = var.service_name
  source_path = var.source_path
  runtime     = var.runtime
  handler     = var.handler

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # --------------------------------------------------------------------------------------------------------------------

  timeout                              = var.timeout
  memory_size                          = var.memory_size
  description                          = var.function_description
  environment_variables                = var.environment_variables
  enable_versioning                    = var.enable_versioning
  iam_role_tags                        = var.iam_role_tags
  lambda_role_permissions_boundary_arn = var.lambda_role_permissions_boundary_arn
  assume_role_policy                   = var.assume_role_policy
  iam_role_name                        = var.iam_role_name
  reserved_concurrent_executions       = var.reserved_concurrent_executions
  architecture                         = var.architecture
  ephemeral_storage                    = var.ephemeral_storage

  tags = var.function_tags
}

module "api_gateway" {
  source = "git@github.com:gruntwork-io/terraform-aws-lambda.git//modules/lambda-http-api-gateway?ref=v0.21.16"

  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------

  name = var.service_name
  route_config = {
    "ANY /{proxy+}" = {
      lambda_function_arn = module.lambda.function_arn
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # --------------------------------------------------------------------------------------------------------------------

  description = var.api_description

  create_route53_entry = var.create_route53_entry
  domain_name          = var.domain_name
  hosted_zone_id       = var.hosted_zone_id
  certificate_domain   = var.certificate_domain

  api_tags   = var.api_tags
  stage_tags = var.stage_tags
}
