terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LOOKUP THE VPC
# ---------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "git@github.com:gruntwork-io/terraform-aws-vpc.git//modules/vpc-app-lookup?ref=v0.26.22"

  # Look up the VPC using tags. The VPC name is also a tag.
  tags = merge({
    Name = var.vpc_name
  }, var.tags)

  # Only lookup the items we enable in the VPC v5 architecture
  lookup_default_security_group = false
  lookup_default_route_table    = false
  lookup_internet_gateway       = true
  lookup_vpc_endpoints          = true
}
