# Null Module

This folder contains a Terraform module which basically does nothing: it takes in some input variables, creates a fake resource (`terraform_data`), and returns some output variables. This is useful for:

 - Mocking the presence of real modules without provisioning anything in AWS
 - Learning
 - Experimenting / testing
 - Etc

## How to try out this module in a sandbox / testing environment

See the [null example](/examples/null).

## Why would I use this module?

Your `infra-live` repo might already have an example of why this module would be used.

By default, "SDLC" repos (e.g. `infra-live-team-xyz`) are populated with a null modules that simply demonstrate
how to use a Terragrunt [`dependency` block](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency):

```hcl
# Look up VPC info using a dependency block
dependency "vpc" {
  # Path to the vpc-app-lookup module that should already be in your infra-live repo
  config_path = "../../networking/vpc"
}

# Use the VPC info to set various inputs
inputs = {
  input_string = dependency.vpc.outputs.vpc_id
}
```

This module can also be useful if you know that you want to provision multiple resources that are interdependent,
but you don't want to spend the time (and money) waiting for them to be fully provisioned within a cloud environment
while you're testing out your code. In that situation, you can use this module to mock the presence of the
other resources, and then when you're ready to deploy for real, you can swap out the null module for the real
one.
