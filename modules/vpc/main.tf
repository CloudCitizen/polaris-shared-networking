terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  # Generate map of all public subnets
  public_subnets = {
    for k, v in var.subnets :
    k => v if coalesce(v["public"], false)
  }
}

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    "Name"       = var.name
    "Compliance" = "ignore" # Shared VPCs are not supported by datadog security rules - https://dev.azure.com/TMNLorg/client-tmnl-implementation/_boards/board/t/Platform/Stories/?workitem=26396
  }
}

# Create Internet Gateway if there's a public subnet
resource "aws_internet_gateway" "this" {
  count = length(local.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "igw-${var.name}"
  }
}

# Subnets
module "subnets" {
  source   = "../subnet"
  for_each = var.subnets

  name     = each.key
  vpc_id   = aws_vpc.this.id
  vpc_name = var.name
  azs      = var.azs
  cidrs    = each.value.cidrs
  public   = coalesce(each.value.public, false)
  tags     = coalesce(each.value.tags, {})
}

# Create NAT gateways in all public subnets
module "nat_gateway" {
  source   = "../nat_gateway"
  for_each = local.public_subnets

  subnet_ids = module.subnets[each.key].subnet_ids
  name       = each.key
  vpc_name   = var.name
  azs        = var.azs
}

# Add routes to NAT/Internet/Transit Gateways
module "subnet_routes" {
  source   = "../subnet_routes"
  for_each = var.subnets

  nat_gateway_ids          = flatten([for k, v in module.nat_gateway : v.nat_gateway_ids])
  internet_gateway_id      = try(aws_internet_gateway.this[0].id, null)
  tgw_id                   = var.tgw_id
  vpc_has_public_subnet    = length(local.public_subnets) > 0 ? true : false
  public_subnet            = coalesce(each.value.public, false)
  cidr_route_table_mapping = module.subnets[each.key].cidr_route_table_mapping
  azs                      = var.azs
  cidrs                    = each.value.cidrs
  allow_outbound_access    = coalesce(each.value.allow_outbound_access, true)

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
###########################
# Default Security Group #
###########################
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}


################################################################################
# Default Network ACLs
################################################################################

# resource "aws_default_network_acl" "this" {
#   count = var.manage_default_network_acl ? 1 : 0

#   default_network_acl_id = aws_vpc.this.default_network_acl_id

#   # subnet_ids is using lifecycle ignore_changes, so it is not necessary to list
#   # any explicitly. See https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/736.
#   subnet_ids = null

#   dynamic "ingress" {
#     for_each = var.default_network_acl_ingress
#     content {
#       action          = ingress.value.action
#       cidr_block      = lookup(ingress.value, "cidr_block", null)
#       from_port       = ingress.value.from_port
#       icmp_code       = lookup(ingress.value, "icmp_code", null)
#       icmp_type       = lookup(ingress.value, "icmp_type", null)
#       ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
#       protocol        = ingress.value.protocol
#       rule_no         = ingress.value.rule_no
#       to_port         = ingress.value.to_port
#     }
#   }
#   dynamic "egress" {
#     for_each = var.default_network_acl_egress
#     content {
#       action          = egress.value.action
#       cidr_block      = lookup(egress.value, "cidr_block", null)
#       from_port       = egress.value.from_port
#       icmp_code       = lookup(egress.value, "icmp_code", null)
#       icmp_type       = lookup(egress.value, "icmp_type", null)
#       ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
#       protocol        = egress.value.protocol
#       rule_no         = egress.value.rule_no
#       to_port         = egress.value.to_port
#     }
#   }

#   tags = merge(
#     { "Name" = coalesce(var.default_network_acl_name, var.name) },
#     var.tags,
#     var.default_network_acl_tags,
#   )

#   lifecycle {
#     ignore_changes = [subnet_ids]
#   }
# }
