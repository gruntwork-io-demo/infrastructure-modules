# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE DB
# ----------------------------------------------------------------------------------------------------------------------

module "aurora_postgresql" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/data-stores/aurora-serverless-postgresql?ref=v0.107.7"
  source = "../../../modules/data-stores/aurora-serverless-postgresql"

  name    = var.name
  db_name = var.db_name

  master_username = var.master_username
  master_password = var.master_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_persistence_subnet_ids

  # Since this is just an example for testing, we skip the final snapshot, as we don't need backups. You probably won't
  # want to set this on production DBs.
  skip_final_snapshot = true
}

# ----------------------------------------------------------------------------------------------------------------------
# RETRIEVE THE DATA FOR THE VPC
# ----------------------------------------------------------------------------------------------------------------------

module "vpc" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/networking/vpc-app-lookup?ref=v0.107.7"
  source = "../../../modules/networking/vpc-app-lookup"

  vpc_name = var.vpc_name
}
