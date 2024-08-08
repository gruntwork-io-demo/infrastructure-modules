# Cluster Stack

This is a stack of units that provision components of an ECS cluster, with segmented state.

## Inputs

- `ClusterName` (string) - The name of the ECS cluster. This is the name that will be used for the cluster.

You will be prompted for this value when used with `terragrunt catalog`.

This is the one variable that's available, but the configuration can be extended to introduce additional values as needed
by altering the [boilerplate.yml](./.boilerplate/boilerplate.yml) file.

## Templating

This stack is generated using [boilerplate](https://github.com/gruntwork-io/boilerplate). You can see an instance of the input above being leveraged
in the [terragrunt.hcl](./.boilerplate/ecs/terragrunt.hcl) file:

```hcl
inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------

  # Description: The name of the ECS cluster (e.g. ecs-prod). This is used to namespace all the resources created by these templates.
  # Type: string
  cluster_name = "{{ .ClusterName }}"
```

## Components of the Stack

This stack is composed of the following units:

- [ecs](./.boilerplate/ecs/terragrunt.hcl) - The ECS cluster itself.
- [vpc](./.boilerplate/vpc/terragrunt.hcl) - The VPC that the ECS cluster will be deployed into.
- [service](./.boilerplate/service/terragrunt.hcl) - A service that will be deployed into the ECS cluster.

Each of these units will provision a collection of AWS resources that are necessary for that component to function with their own state.

The stack is designed to be modular, so you can add or remove components as needed.

Look to the `dependency` block in the `terragrunt.hcl` files to see how the units are linked together.

## The Directed Acyclic Graph (DAG)

Terragrunt leverages what is called a Directed Acyclic Graph (DAG) to determine the order in which to apply the Terraform configurations.

It uses dependency information to determine the proper ordering of updates to units.

In this stack, dependencies are applied in the following order:

1. VPC
2. ECS
3. Service

This ensures that when the service is being provisioned, it first looks to provision the ECS Cluster, and when the ECS cluster is to be provisioned, it first provisions the VPC.

Running the following:

```bash
terragrunt run-all apply
```

Will apply the configurations in the correct order.

Similarly, when destroying the stack, the order is reversed:

1. Service
2. ECS
3. VPC

This ensures that when the stack is being destroyed, the service is removed first, then the ECS cluster, and finally the VPC.

```bash
terragrunt run-all destroy
```

