output "api_endpoint" {
  description = "The URI of the API. The domain_name input, if create_route53_entry is set, will route to this endpoint."
  value       = module.lambda_api.api_endpoint
}
