terraform {
  required_version = ">= 1.4.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create null resource
# ---------------------------------------------------------------------------------------------------------------------

resource "terraform_data" "null" {
  input            = "${var.input_string}-[${join(",", var.input_list)}]"
  triggers_replace = var.triggers_replace
}
