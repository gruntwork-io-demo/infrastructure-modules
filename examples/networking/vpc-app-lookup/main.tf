# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# LOOKUP THE VPC
# ----------------------------------------------------------------------------------------------------------------------

module "lookup" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/networking/vpc-app-lookup?ref=v0.107.7"
  source = "../../../modules/networking/vpc-app-lookup"

  vpc_name = var.vpc_name
  tags     = var.tags
}
