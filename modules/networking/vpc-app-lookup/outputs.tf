output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_name" {
  value = module.vpc.vpc_name
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "ipv6_cidr_block" {
  value = module.vpc.ipv6_cidr_block
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_app_subnets" {
  value = module.vpc.private_app_subnets
}

output "private_persistence_subnets" {
  value = module.vpc.private_persistence_subnets
}

output "transit_subnets" {
  value = module.vpc.transit_subnets
}

output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnet_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  value = module.vpc.public_subnet_ipv6_cidr_blocks
}

output "private_app_subnet_cidr_blocks" {
  value = module.vpc.private_app_subnet_cidr_blocks
}

output "private_persistence_subnet_cidr_blocks" {
  value = module.vpc.private_persistence_subnet_cidr_blocks
}

output "transit_subnet_cidr_blocks" {
  value = module.vpc.transit_subnet_cidr_blocks
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "private_persistence_subnet_ids" {
  value = module.vpc.private_persistence_subnet_ids
}

output "transit_subnet_ids" {
  value = module.vpc.transit_subnet_ids
}

output "public_subnet_arns" {
  value = module.vpc.public_subnet_arns
}

output "private_app_subnet_arns" {
  value = module.vpc.private_app_subnet_arns
}

output "private_persistence_subnet_arn" {
  value = module.vpc.private_persistence_subnet_arn
}

output "transit_subnet_arns" {
  value = module.vpc.transit_subnet_arns
}

output "default_route_table_id" {
  value = module.vpc.default_route_table_id
}

output "public_subnet_route_table_id" {
  value = module.vpc.public_subnet_route_table_id
}

output "public_subnet_route_table_ids" {
  value = module.vpc.public_subnet_route_table_ids
}

output "private_app_subnet_route_table_ids" {
  value = module.vpc.private_app_subnet_route_table_ids
}

output "private_subnet_route_table_ids" {
  value = module.vpc.private_subnet_route_table_ids
}

output "private_persistence_route_table_ids" {
  value = module.vpc.private_persistence_route_table_ids
}

output "private_persistence_subnet_route_table_ids" {
  value = module.vpc.private_persistence_subnet_route_table_ids
}

output "transit_subnet_route_table_ids" {
  value = module.vpc.transit_subnet_route_table_ids
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_gateway_public_ips
}

output "private_nat_gateway_ids" {
  value = module.vpc.private_nat_gateway_ids
}

output "num_availability_zones" {
  value = module.vpc.num_availability_zones
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

output "s3_vpc_endpoint_id" {
  value = module.vpc.s3_vpc_endpoint_id
}

output "dynamodb_vpc_endpoint_id" {
  value = module.vpc.dynamodb_vpc_endpoint_id
}