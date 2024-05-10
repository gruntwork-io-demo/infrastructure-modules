# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed in by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "master_username" {
  description = "The value to use for the master username of the database."
  type        = string
}

variable "master_password" {
  description = "The value to use for the master password of the database."
  type        = string
  sensitive   = true
}

variable "vpc_name" {
  description = "The name of the VPC to use for testing"
  type        = string
}

#---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These values may optionally be overwritten by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name used to namespace all the Aurora resources created by these templates, including the cluster and cluster instances (e.g. drupaldb). Must be unique in this region. Must be a lowercase string."
  type        = string
  default     = "example-db"
}

variable "db_name" {
  description = "The name for your PostgreSQL database of up to 8 alpha-numeric characters."
  type        = string
  default     = "example"
}