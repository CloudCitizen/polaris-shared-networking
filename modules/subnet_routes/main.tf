# For public subnets, add (default) route to internet gateway
resource "aws_route" "to_internet_gateway" {
  for_each = var.public_subnet && var.allow_outbound_access ? toset(var.cidrs) : []

  route_table_id         = lookup(var.cidr_route_table_mapping, each.key)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# For private subnets in a VPC with a public subnet, add (default) route to the NAT gateways
resource "aws_route" "to_nat_gateway" {
  for_each = (var.vpc_has_public_subnet && !var.public_subnet && var.allow_outbound_access) ? toset(var.cidrs) : []

  route_table_id         = lookup(var.cidr_route_table_mapping, each.key)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(var.nat_gateway_ids, index(var.cidrs, each.key))
}

# For all subnets in VPCs with a public subnet, add a more-specific route to the Transit Gateway
# This can't be a default route (all), as a default route to the NAT/Internet gateway(s) is needed
resource "aws_route" "to_transit_gateway_specific" {
  for_each               = var.vpc_has_public_subnet && var.allow_outbound_access ? toset(var.cidrs) : []
  route_table_id         = lookup(var.cidr_route_table_mapping, each.key)
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.tgw_id
}

# For subnets in a VPC without public subnet, add (default) route to the Transit Gateway
resource "aws_route" "to_transit_gateway_all" {
  for_each               = var.vpc_has_public_subnet ? [] : (var.allow_outbound_access ? toset(var.cidrs) : [])
  route_table_id         = lookup(var.cidr_route_table_mapping, each.key)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id
}
