#---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These values may optionally be overwritten by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "input_string" {
  description = "The input string that controls replacement of the `terraform_data.null` resource. Whenever either this input or the `input_list` changes, the `terraform_data.null` resource will be replaced."
  type        = string
  default     = null
}

variable "input_list" {
  description = "The input list that controls replacement of the `terraform_data.null` resource. Whenever either this input or the `input_string` changes, the `terraform_data.null` resource will be replaced."
  type        = list(string)
  default     = []
}

variable "triggers_replace" {
  description = "The resources that control replacement of the `terraform_data.null` resource. Whenever any of these resources change, the `terraform_data.null` resource will be replaced."
  default     = null
}
