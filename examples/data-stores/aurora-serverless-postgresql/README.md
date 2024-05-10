# Aurora Serverless V2 PostgreSQL example

This is an example of how to use the
[aurora-serverless-postgresql module](/modules/data-stores/aurora-serverless-postgresql) to deploy an Aurora Serverless
V2 database with PostgreSQL compatibility.

## Quick start

1. Authenticate to an AWS account with a VPC that is already deployed.
2. Open `variables.tf` and fill in the VPC name in `vpc_name`.
3. Set the DB master username and password as environment variables:

    ```bash
    export TF_VAR_master_username=<USERNAME> 
    export TF_VAR_master_password=<PASSWORD> 
    ```
5. Run `terraform init`.
6. Run `terraform apply`.
