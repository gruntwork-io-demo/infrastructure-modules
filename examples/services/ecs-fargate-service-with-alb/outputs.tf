output "service_arn" {
  description = "The ARN of the ECS service"
  value       = module.ecs_service.service_arn
}

output "service_dns_name" {
  description = "The domain name to use to access the service via the ALB."
  value       = module.ecs_service.service_dns_name
}
