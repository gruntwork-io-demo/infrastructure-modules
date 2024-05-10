terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A FARGATE ECS CLUSTER
# With Fargate, ECS clusters are just logical entities. To keep this module simple, we are creating a separate cluster
# for each service. If you wish to share an ECS cluster amongst many services, pull the ecs-fargate-cluster usage
# outside of this module, and pass the name and ARN as input variables into this module.
# ---------------------------------------------------------------------------------------------------------------------

module "ecs_cluster" {
  source = "git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/services/ecs-fargate-cluster?ref=v0.111.2"

  cluster_name = var.service_name
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE ECS SERVICE INTO THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Here, we are configuring the ECS container definition. Note that we are only setting a handful of the options
  # available. See https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html for the full
  # set of options.
  container_definition = {
    name        = var.service_name
    image       = var.docker_image
    memory      = var.memory
    essential   = true
    Environment = var.environment_variables
    portMappings = [
      {
        containerPort = var.container_port
      }
    ]
  }
}

module "ecs_service" {
  source = "git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/services/ecs-service?ref=v0.111.2"

  service_name = var.service_name
  launch_type  = "FARGATE"

  ecs_cluster_arn  = module.ecs_cluster.arn
  ecs_cluster_name = module.ecs_cluster.name

  container_definitions   = [local.container_definition]
  task_cpu                = var.cpu
  task_memory             = var.memory
  desired_number_of_tasks = var.desired_number_of_tasks

  network_mode = "awsvpc"
  network_configuration = {
    vpc_id                        = var.vpc_id
    subnets                       = var.service_subnet_ids
    additional_security_group_ids = []
    assign_public_ip              = true

    # Allow the container to make outbound requests as necessary. Allow inbound requests only from the ALB.
    security_group_rules = {
      AllowAllEgress = {
        type                     = "egress"
        from_port                = 0
        to_port                  = 0
        protocol                 = "-1"
        cidr_blocks              = ["0.0.0.0/0"]
        source_security_group_id = null
      }
      AllowALBIngress = {
        type                     = "ingress"
        from_port                = var.container_port
        to_port                  = var.container_port
        protocol                 = "tcp"
        cidr_blocks              = null
        source_security_group_id = module.alb.alb_security_group_id
      }
    }
  }

  # Prevent getting stuck in a continuous loop of redeploys if a deploy fails, and instead, rollback after a failure
  deployment_circuit_breaker_enabled  = true
  deployment_circuit_breaker_rollback = true

  # Configure a target group on the ALB that points to the service and does health checks at the specified port
  elb_target_groups = {
    alb = {
      name                  = var.service_name
      container_name        = local.container_definition.name
      container_port        = var.container_port
      protocol              = "HTTP"
      health_check_protocol = "HTTP"
    }
  }
  elb_target_group_vpc_id = var.vpc_id

  # Load balancer listener rules
  default_listener_arns  = module.alb.listener_arns
  default_listener_ports = [tostring(local.alb_default_listener_port)]
  forward_rules          = var.forward_rules
  redirect_rules         = var.redirect_rules
  fixed_response_rules   = var.fixed_response_rules

  # Ensure the load balancer is provisioned before the ecs service is created
  dependencies = [module.alb.alb_arn]
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AN APPLICATION LOAD BALANCER (ALB)
# This allows us to expose this ECS service to the world. To keep this module simple, we are creating a separate ALB
# for each service. If you wish to share an ALB amongst many services, pull the alb usage
# outside of this module, and pass the ALB name and ARNs as input variables to this module.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  alb_default_listener_port = 80
}

module "alb" {
  source = "git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/networking/alb?ref=v0.111.2"

  alb_name = var.service_name

  # Make this a public ALB that allows inbound connections from anywhere
  allow_inbound_from_cidr_blocks = ["0.0.0.0/0"]
  is_internal_alb                = false

  # Have the ALB listen on the default HTTP port (80)
  http_listener_ports = [local.alb_default_listener_port]

  # To enable the ALB to listen for HTTPS requests, you need to (a) configure a custom domain name and (b) provide a
  # TLS certificate for that domain. To keep this example simple, we are just enabling HTTP.
  #
  # https_listener_ports_and_acm_ssl_certs = [
  #   {
  #     port            = 443
  #     tls_domain_name = "*.example.com"
  #   }
  # ]

  vpc_id         = var.vpc_id
  vpc_subnet_ids = var.alb_subnet_ids

  num_days_after_which_archive_log_data = 30
  num_days_after_which_delete_log_data  = 365
  force_destroy                         = var.force_destroy
}
