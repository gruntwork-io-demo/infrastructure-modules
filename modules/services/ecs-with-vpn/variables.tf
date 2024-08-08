
# VPC Config
variable "vpc_name" {
}


variable "num_nat_gateways" {
  default = 1
}

variable "vpc_cidr_block" {
  default = "10.100.0.0/16"
}

# ECS Config
variable "cluster_name" {
}

variable "cluster_min_size" {
    default = 1
}

variable "cluster_max_size" {
    default = 2
}

variable "cluster_instance_ami" {
}

variable "cluster_instance_type" {
    default = "t2.medium"
}

variable "cluster_instance_keypair_name" {
    default = null
}

# Service Config

variable "service_name" {
}

variable desired_number_of_tasks {
    default = 1
}

variable "ecs_task_container_definitions" {
}
