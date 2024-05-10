# ECS Fargate Service with ALB

This is an example module that wraps several Gruntwork modules to deploy an ECS Fargate Service and an Application Load 
Balancer (ALB) to distribute traffic across that service. 

## What this module does

**Note**: this module is meant as a _starting point_. It makes a number of assumptions, as listed below, that you may 
need to tweak for your use cases. We fully expect you to customize this module to your needs!

1. Create an ECS Fargate cluster for each ECS service. If you wish to share one ECS cluster amongst many services, 
   modify the module to extract the ECS Fargate cluster portion into a separate module.
2. Configure an ECS task container definition for deploying your Docker image. We only set a small handful of the 
   [available parameters](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html). If
   you wish to set more parameters, modify the `container_definition` in the module.
3. Configure the ECS task to run as an ECS Fargate service with a fixed number of instances set by 
   `var.desired_number_of_tasks`. Auto scaling is not enabled. If you wish to enable auto scaling, see the 
   `use_auto_scaling`, `min_number_of_tasks`, and `max_number_of_tasks` parameters on the wrapped `ecs-service` module. 
4. Configure the ECS service to allow all outbound network requests and only allow inbound network requests from the 
   ALB on `var.container_port`. The ALB will send all requests and health checks to this port. If you need to expose
   multiple ports, modify the `portMappings` and `network_configuration` in this module.
5. Deploy an ALB that listens solely on the default HTTP port (80). Normally, you should also configure the ALB to 
   listen for HTTPS requests (port 443), but that requires a TLS cert and custom domain name. To keep the module simple,
   we've _not_ enable HTTPS on it, but you will likely want to modify the module for real world use cases to do HTTPS,
   configuring it with either ACM-managed or IAM-managed TLS certificates.

## How to try out this module in a sandbox / testing environment

See the [ecs-fargate-service-with-alb example](/examples/services/ecs-fargate-service-with-alb).

## How to deploy this module in a real environment (e.g., dev/stage/prod)

1. Install [Terragrunt](https://terragrunt.gruntwork.io/).

2. Check out your team's `infra-live` repo (replace `INFRA_LIVE_REPO_URL` with the repo URL in the command below): 

    ```bash
    git clone <INFRA_LIVE_REPO_URL>
    ```

3. Create a new branch (replace `SERVICE_NAME` with the name for the service in the command below): 

    ```bash
    git checkout -b deploy-<SERVICE_NAME>
    ```

4. Create a folder for this ECS service and go into that folder (replace `SERVICE_NAME` with the name for the service 
   and `AWS_REGION` with the AWS region you're using in your `infra-live` repo in the command below): 

    ```bash
    mkdir -p dev/<AWS_REGION>/services/<SERVICE_NAME>
    cd dev/<AWS_REGION>/services/<SERVICE_NAME>
    ```

5. Run Terragrunt to scaffold out a `terragrunt.hcl` for the service: 

    ```bash
    terragrunt scaffold github.com/gruntwork-io/infrastructure-modules//modules/services/ecs-fargate-service-with-alb
    ```

6. The previous step will create a `terragrunt.hcl` file. Open it up and fill in the input variables as specified.

7. Add, commit, and push your changes to Git (replace `SERVICE_NAME` with the name for the service in the command below): 

    ```bash
    git add terragrunt.hcl
    git commit -m "Deploy service <SERVICE_NAME>"
    git push origin deploy-<SERVICE_NAME>
    ```

8. Navigate to your `infra-live` repo in your web browser and [open a pull 
   request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request).

9. The CI / CD pipeline will automatically run `plan` on your pull request.

10. If everything looks OK with the code changes and `plan` output, merge the pull request, and the CI / CD pipeline 
    will automatically run `apply` to deploy your service. 