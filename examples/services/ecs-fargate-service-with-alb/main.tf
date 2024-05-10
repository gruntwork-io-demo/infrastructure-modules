# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE ECS SERVICE
# ----------------------------------------------------------------------------------------------------------------------

module "ecs_service" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/services/ecs-fargate-service-with-alb?ref=v0.107.7"
  source = "../../../modules/services/ecs-fargate-service-with-alb"

  service_name = var.service_name

  # Simple official Docker image that runs a "Hello, World" webapp on port 5000
  # https://github.com/docker-training/webapp
  docker_image   = "training/webapp"
  container_port = 5000
  # If you set the PROVIDER environment variable, docker-training/webapp will return the text "Hello, <PROVIDER>"
  environment_variables = [
    {
      name  = "PROVIDER"
      value = var.text
    }
  ]

  # Minimal CPU and memory for this simple example
  cpu    = 256
  memory = 512

  # Run 2 tasks. The ALB will distribute traffic across them.
  desired_number_of_tasks = 2

  # Configure the ALB to send all paths to this task
  forward_rules = {
    all = {
      path_patterns = ["*"]
    }
  }

  # Run in the VPC in this account, with the ALB in the public subnets and the ECS service in the private-app subnets
  vpc_id             = module.vpc.vpc_id
  alb_subnet_ids     = module.vpc.public_subnet_ids
  service_subnet_ids = module.vpc.private_app_subnet_ids

  # Since this example is used only for testing, we set force_destroy to true, ensuring everything is cleaned up
  # correctly when you run 'destroy'. In prod, you would NOT want to set this to true until you backed up your access
  # logs somewhere.
  force_destroy = true
}

# ----------------------------------------------------------------------------------------------------------------------
# RETRIEVE THE DATA FOR THE VPC
# ----------------------------------------------------------------------------------------------------------------------

module "vpc" {
  # When using these modules in your own repos, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git@github.com:gruntwork-io/infrastructure-modules.git//modules/networking/vpc-app-lookup?ref=v0.107.7"
  source = "../../../modules/networking/vpc-app-lookup"

  vpc_name = var.vpc_name
}
