output "vpc_id" {
  value = module.lookup.vpc_id
}

output "vpc_name" {
  value = module.lookup.vpc_name
}

output "vpc_cidr_block" {
  value = module.lookup.vpc_cidr_block
}

output "ipv6_cidr_block" {
  value = module.lookup.ipv6_cidr_block
}

output "default_security_group_id" {
  value = module.lookup.default_security_group_id
}

output "public_subnets" {
  value = module.lookup.public_subnets
}

output "private_app_subnets" {
  value = module.lookup.private_app_subnets
}

output "private_persistence_subnets" {
  value = module.lookup.private_persistence_subnets
}

output "transit_subnets" {
  value = module.lookup.transit_subnets
}

output "public_subnet_cidr_blocks" {
  value = module.lookup.public_subnet_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  value = module.lookup.public_subnet_ipv6_cidr_blocks
}

output "private_app_subnet_cidr_blocks" {
  value = module.lookup.private_app_subnet_cidr_blocks
}

output "private_persistence_subnet_cidr_blocks" {
  value = module.lookup.private_persistence_subnet_cidr_blocks
}

output "transit_subnet_cidr_blocks" {
  value = module.lookup.transit_subnet_cidr_blocks
}

output "public_subnet_ids" {
  value = module.lookup.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.lookup.private_app_subnet_ids
}

output "private_persistence_subnet_ids" {
  value = module.lookup.private_persistence_subnet_ids
}

output "transit_subnet_ids" {
  value = module.lookup.transit_subnet_ids
}

output "public_subnet_arns" {
  value = module.lookup.public_subnet_arns
}

output "private_app_subnet_arns" {
  value = module.lookup.private_app_subnet_arns
}

output "private_persistence_subnet_arn" {
  value = module.lookup.private_persistence_subnet_arn
}

output "transit_subnet_arns" {
  value = module.lookup.transit_subnet_arns
}

output "default_route_table_id" {
  value = module.lookup.default_route_table_id
}

output "public_subnet_route_table_id" {
  value = module.lookup.public_subnet_route_table_id
}

output "public_subnet_route_table_ids" {
  value = module.lookup.public_subnet_route_table_ids
}

output "private_app_subnet_route_table_ids" {
  value = module.lookup.private_app_subnet_route_table_ids
}

output "private_subnet_route_table_ids" {
  value = module.lookup.private_subnet_route_table_ids
}

output "private_persistence_route_table_ids" {
  value = module.lookup.private_persistence_route_table_ids
}

output "private_persistence_subnet_route_table_ids" {
  value = module.lookup.private_persistence_subnet_route_table_ids
}

output "transit_subnet_route_table_ids" {
  value = module.lookup.transit_subnet_route_table_ids
}

output "internet_gateway_id" {
  value = module.lookup.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.lookup.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  value = module.lookup.nat_gateway_public_ips
}

output "private_nat_gateway_ids" {
  value = module.lookup.private_nat_gateway_ids
}

output "num_availability_zones" {
  value = module.lookup.num_availability_zones
}

output "availability_zones" {
  value = module.lookup.availability_zones
}

output "s3_vpc_endpoint_id" {
  value = module.lookup.s3_vpc_endpoint_id
}

output "dynamodb_vpc_endpoint_id" {
  value = module.lookup.dynamodb_vpc_endpoint_id
}