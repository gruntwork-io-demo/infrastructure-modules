# ----------------------------------------------------------------------------------------------------------------------
# PRETEND TO RETRIEVE THE DATA
# ----------------------------------------------------------------------------------------------------------------------

module "lookup" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/null?ref=v0.107.7"
  source = "../../../modules/mock/null"

  # Pretend this is the name of the VPC we want to retrieve
  input_string = "VPC Name"
}

# ----------------------------------------------------------------------------------------------------------------------
# PROVISION THE NULL MODULE
# ----------------------------------------------------------------------------------------------------------------------

module "null" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/null?ref=v0.107.7"
  source = "../../../modules/mock/null"

  # Pretend this is the VPC ID we retrieved from the module above
  input_string = module.lookup.output

  # Pretend this is the list of subnet IDs we retrieved from the module above
  input_list = module.lookup.output_list
}
