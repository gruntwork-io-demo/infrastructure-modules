output "cluster_id" {
  description = "The ID of the RDS Aurora cluster (e.g TODO)."
  value       = module.aurora_postgresql.cluster_id
}

output "cluster_resource_id" {
  description = "The unique resource ID assigned to the cluster e.g. cluster-POBCBQUFQC56EBAAWXGFJ77GRU. This is useful for allowing database authentication via IAM."
  value       = module.aurora_postgresql.cluster_resource_id
}

output "cluster_arn" {
  description = "The ARN of the RDS Aurora cluster."
  value       = module.aurora_postgresql.cluster_arn
}

output "primary_endpoint" {
  description = "The primary endpoint of the RDS Aurora cluster that you can use to make requests to."
  value       = module.aurora_postgresql.primary_endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas."
  value       = module.aurora_postgresql.reader_endpoint
}

output "primary_host" {
  description = "The host portion of the Aurora endpoint. primary_endpoint is in the form '<host>:<port>', and this output returns just the host part."
  value       = module.aurora_postgresql.primary_host
}

output "instance_endpoints" {
  description = "A list of endpoints of the RDS instances that you can use to make requests to."
  value       = module.aurora_postgresql.instance_endpoints
}

output "port" {
  description = "The port used by the RDS Aurora cluster for handling database connections."
  value       = module.aurora_postgresql.port
}

output "security_group_id" {
  description = "ID of security group created by aurora module."
  value       = module.aurora_postgresql.security_group_id
}
