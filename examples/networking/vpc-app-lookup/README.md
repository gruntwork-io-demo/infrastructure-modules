# VPC-App lookup example

This is an example of how to use the [vpc-app-lookup module](/modules/networking/vpc-app-lookup) to look up the data 
for a VPC.

## Quick start

1. Authenticate to an AWS account with a VPC that is already deployed.
2. Open `variables.tf` and fill in the VPC name in `vpc_name`.
3. Run `terraform init`.
4. Run `terraform apply`.
5. After `apply` finishes, the output variables will contain all the information about the VPC.
