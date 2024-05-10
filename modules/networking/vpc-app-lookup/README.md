# VPC-App Lookup Module

This folder contains a Terraform module which can use data sources to fetch all the data about a VPC created by the
`vpc-app` module, including the VPC ID, subnet IDs, route table IDs, NAT Gateway 
IDs, and so on. Normally, you can look up this data using either a `dependency` block in Terragrunt or a 
`terraform_remote_state` data source in Terraform, but in some cases, the VPC is managed in a separate repo 
than your apps, so you don't have access to the code or state. Therefore, this `vpc-app-lookup` 
module allows you to fetch all the info you need without having to have access to the code or Terraform state.

This module attempts to match the output variables API of the `vpc-app` module exactly.

## How to try out this module in a sandbox / testing environment

See the [vpc-app-lookup example](/examples/networking/vpc-app-lookup).

## How to deploy this module in a real environment (e.g., dev/stage/prod)

Your `infra-live` repo should _already_ have this module deployed!

To read the VPC data from it in another module, you can use a Terragrunt [`dependency` 
block](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency):

```hcl
# Look up VPC info using a dependency block
dependency "vpc" {
  # Path to the same vpc-app-lookup module that is already deployed in your infra-live repo!
  config_path = "../../networking/vpc"
}

# Use the VPC info to set various inputs
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}
```