# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

module "lambda_api" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/services/lambda-api?ref=v0.1.1"
  source = "../../../modules/services/lambda-api"

  service_name = var.service_name
  source_path  = var.source_path
  runtime      = var.runtime
  handler      = var.handler

  architecture = var.architecture
}
