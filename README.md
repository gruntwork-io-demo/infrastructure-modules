# Infrastructure Modules

This repository contains Terraform modules. Think of these modules as "blueprints" that define reusable, testable, configurable, versioned pieces of infrastructure. Find your team's `infrastructure-live` repo to see how these blueprints are used.

Note that some of these modules rely on modules that are part of [Gruntwork](https://docs.gruntwork.io/library/reference/) Library. The Gruntwork modules live in private Git repos, and if you don't have access to those repos, please email <support@gruntwork.io>.

## How to add a new module

As an example, we'll add a module that provisions an AWS Lambda Function and HTTP API Gateway, with a single proxy route on the API Gateway pointing to the Lambda. This service exposes a simple set of inputs for configuring the Lambda code configuration and name of the provisioned resources

### Create the basic file structure

We’ll create three files — `main.tf` which will contain the resource definitions, `variables.tf`, which specifies the possible inputs to the module, and `outputs.tf`, which specifies the values that can be used to pass references to attributes from the resources in the module.

```shell
mkdir -p services/serverless-api/
touch services/serverless-api/main.tf
touch services/serverless-api/variables.tf
touch services/serverless-api/outputs.tf
```

### Define the module

Next, define the module blocks using the Gruntwork Lambda function module and HTTP API Gateway module.

**services/serverless-api/main.tf**

```hcl
module "lambda" {
  source = "git@github.com:gruntwork-io/terraform-aws-lambda.git//modules/lambda?ref=v0.21.9"
  name        = "${var.name}-name"
  runtime     = var.lambda_runtime
  source_path = var.lambda_source_path
  handler     = var.lambda_handler
  run_in_vpc  = false
  timeout     = 30
  memory_size = 128
}

module "api" {
  source = "git@github.com:gruntwork-io/terraform-aws-lambda.git//modules/lambda-http-api-gateway?ref=v0.21.9"

  name = "${var.name}-api-gw"
  route_config = {
    "ANY /{proxy+}": {
        lambda_function_arn = module.lambda.function_arn
    }
  }
}
```

### Specify the variables

Now that you’ve defined the resources you want to create, you need to define the variables that you want to allow users to pass into the module. You can reference these values in the module using the var syntax, as visible in `services/serverless-api/main.tf`.

**services/serverless-api/variables.tf**

```hcl
variable "name" {
  description = "The name used to namespace all the resources, including the API Gateway and Lambda functions."
  type        = string
}

variable "lambda_runtime" {
  type        = string
  description = "The runtime of the Lambda. Options include go, python, ruby, etc."
}

variable "lambda_source_path" {
  type        = string
  description = "The path to the directory containing the source to be deployed to lambda"
}

variable "lambda_handler" {
  type        = string
  description = "The name of the handler function that will be called as the entrypoint of the lambda"
}

```

### Specify the outputs

Next, define the outputs from the module. Outputs are convenient ways to pass values between modules when composing a service comprised of many modules. For this example, we only want a single output — the URL for the API we are provisioning. You may want to define more outputs when developing a module for your company or team. Refer to the Library Reference for the [Lambda function module](https://docs.gruntwork.io/reference/modules/terraform-aws-lambda/lambda/#reference) and [HTTP API Gateway module](https://docs.gruntwork.io/reference/modules/terraform-aws-lambda/lambda-http-api-gateway/#reference) for a full list of outputs available.

**services/serverless-api/outputs.tf**

```hcl
output "api_endpoint" {
  description = "The URI of the API."
  value       = module.api.api_endpoint
}
```

## How do you use a module?

To use a module in your `infrastructure-live` repository, create a `terragrunt.hcl` file, in your desired environment's folder, that specifies the module you want to use as well as values for the input variables of that module:

**example_app/terragrunt.hcl**

```hcl
# Include the root `terragrunt.hcl` configuration, which has settings common across all environments & components.
include "root" {
  path = find_in_parent_folders()
}

# Use Terragrunt to download the module code
terraform {
  source = "git@github.com:gruntwork-io/infrastructure-modules.git//path/to/module?ref=v0.0.1"
}

# Fill in the variables for that module
inputs = {
  name               = "gw-guide-serverless-api"
  lambda_runtime     = "python3.9"
  lambda_source_path = "${path.module}/src"
  lambda_handler     = "main.lambda_handler"
}
```

(_Note: the double slash (`//`) in the `source` URL is intentional and required. It's part of Terraform's Git syntax
for [module sources](https://www.terraform.io/docs/modules/sources.html)._)

You then run [Terragrunt](https://github.com/gruntwork-io/terragrunt), a thin, open source wrapper for Terraform
that supports locking and enforces best practices, and it will download the source code specified in the `source` URL
into a temporary folder, copy your `terragrunt.hcl` file into that folder, and run your Terraform command in that
folder:

```
> terragrunt apply
[terragrunt] Reading Terragrunt config file at terragrunt.hcl
[terragrunt] Downloading Terraform configurations from github.com/gruntwork-io/infrastructure-modules//path/to/module?ref=v0.0.1
[terragrunt] Copying files from . into /tmp/terragrunt/infrastructure-modules/path/to/module
[terragrunt] Running command: terraform apply
[...]
```

## How do you change a module?

### Local changes

Here is how to test out changes to a module locally:

1. Update the code as necessary.
1. Go into the folder where you have the `terragrunt.hcl` file that uses this module (preferably for a dev or
   staging environment!).
1. Run `terragrunt plan --terragrunt-source <LOCAL_PATH>`, where `LOCAL_PATH` is the path to your local checkout of
   the module code.
1. If the plan looks good, create a pull request and merge it.

Using the `--terragrunt-source` parameter (or `TERRAGRUNT_SOURCE` environment variable) allows you to do rapid,
iterative, make-a-change-and-rerun development. Note that Terragrunt uses a cache which manifests as a `.terragrunt-cache` folder in the current working directory. If you want to clear the cache; remove the `.terragrunt-cache` folder and run `terragrunt plan` again.

### Releasing a new version

When you're done testing the changes locally and have merged your Pull request, here is how you release a new version:

1. Add a new Git tag using one of the following options:

   1. Using GitHub: Go to the [releases page](/releases) and click "Draft a new release".
   1. Using Git:

   ```
   git tag -a v0.0.2 -m "tag message"
   git push --follow-tags
   ```

1. Now you can use the new Git tag (e.g. `v0.0.2`) in the `ref` attribute of the `source` URL in `terragrunt.hcl`.

## Why use modules?

Modules offer a few key advantages:

1. **Keep your code DRY**: Instead of copying & pasting Terraform code across each environments, you define your code
   in a single place (this repo) and reuse that exact same code across all environments just by referencing the
   code's URL in a `terragrunt.hcl` file.
1. **Keep your code versioned**: By using versioned `source` URLs (via the `?ref=XXX` parameter), you can test out a
   new version in one environment (e.g. stage) without affecting another environment (e.g. prod). If the changes look
   good, you can promote that same version to every other environment in succession (e.g. dev -> stage -> prod). And
   since the version is immutable, you can be confident that if it worked in a previous environment, it'll work the
   same way in another environment.
