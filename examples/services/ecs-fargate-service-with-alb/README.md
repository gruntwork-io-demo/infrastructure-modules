# ECS Fargate Service with ALB example

This is an example of how to use the 
[ecs-fargate-service-with-alb module](/modules/services/ecs-fargate-service-with-alb) to deploy an ECS Service with an
Application Load Balancer (ALB).

## Quick start

1. Authenticate to an AWS account with a VPC that is already deployed.
2. Open `variables.tf` and fill in the VPC name in `vpc_name`. 
3. Run `terraform init`.
4. Run `terraform apply`.
5. After `apply` finishes, the `service_dns_name` output will contain the domain name of the ALB. Use `curl` or a web
   browser to open this URL to see if your ECS service is responding to requests.
