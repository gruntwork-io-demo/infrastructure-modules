# Lambda Function with API Gateway

This is an example module that wraps two Gruntwork modules to deploy an Lambda function and an API Gateway to invoke that
function via HTTPS requests.

## What this module does

**Note**: this module is meant as a _starting point_. It makes a number of assumptions, as listed below, that you may
need to tweak for your use cases. We fully expect you to customize this module to your needs!

> :bulb: To see the full list of available configurations for these modules, see modules [here](https://github.com/gruntwork-io/terraform-aws-lambda).

1. Create a Lambda function that deploys a zip file containing the archived contents of a local directory as defined by
   `source_path`.
2. The Lambda function will _not_ be running a Docker image.
3. An IAM role will be created for your Lambda function with minimal permissions to access AWS resources.
4. An API Gateway will be created that invokes the Lambda function when an HTTP request is received at any URI or method.
5. The Lambda function will have no VPC connectivity.

## How to try out this module in a sandbox / testing environment

See the [lambda-api example](/examples/services/lambda-api).

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
    terragrunt scaffold github.com/gruntwork-io/infrastructure-modules//modules/services/lambda-api
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
