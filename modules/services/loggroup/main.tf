resource "aws_cloudwatch_log_group" "log_aggregation" {
  name              = var.log_group_name
  retention_in_days = 5
  tags              = []
}