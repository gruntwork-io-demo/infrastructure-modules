# Lambda with API Gateway example

This is an example of how to use the
[lambda-api module](/modules/services/lambda-api) to deploy a Lambda function with an
API Gateway (API GW).

## Quick start

1. Authenticate to an AWS account.
2. Run `terraform init`.
3. Run `terraform apply`.
4. After `apply` finishes, the `api_endpoint` output will contain the domain name of the API Gateway. Use `curl` or a web
   browser to open this URL to see if your Lambda API service is responding to requests.
