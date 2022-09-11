# Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description                     = "tgw"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"

  tags = {
    "Name" = "tgw"
  }
}

# The Transit Gateway VPC attachment is done in the VPC module (due to required dependencies for routes)

# Transit Gateway routing tables (1 per VPC attachment)
resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each           = var.vpcs
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "tgw-rtb-${each.key}"
  }
}

# Associate routing table with Transit Gateway attachment
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each                       = var.vpcs
  transit_gateway_attachment_id  = module.vpc[each.key].tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.key].id
}

# Setup routes and propagations
module "tgw_routes" {
  source = "./modules/tgw_routes"

  for_each = var.vpcs

  tgw_propagations   = each.value.tgw_propagations
  tgw_attachment_ids = { for k, v in module.vpc : k => v.tgw_attachment_id }
  tgw_route_table_id = aws_ec2_transit_gateway_route_table.this[each.key].id
}
