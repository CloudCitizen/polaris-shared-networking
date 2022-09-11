resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each                       = toset(var.tgw_propagations)
  transit_gateway_route_table_id = var.tgw_route_table_id
  transit_gateway_attachment_id  = var.tgw_attachment_ids[each.key]
}

# Add default routes for VPCs with the egress propagation
resource "aws_ec2_transit_gateway_route" "egress_route" {
  for_each                       = contains(var.tgw_propagations, "egress") ? toset(["this"]) : []
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = var.tgw_route_table_id
  transit_gateway_attachment_id  = var.tgw_attachment_ids["egress"]
}

# Add blackhole routes for all private IPv4 ranges
resource "aws_ec2_transit_gateway_route" "blackhole" {
  for_each                       = toset(["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"])
  destination_cidr_block         = each.key
  blackhole                      = true
  transit_gateway_route_table_id = var.tgw_route_table_id
}
