module "vpc" {
  source   = "./modules/vpc"
  for_each = var.vpcs

  name            = each.key
  cidr            = each.value.cidr
  azs             = lookup(each.value, "azs", ["${var.region}a", "${var.region}b", "${var.region}c"])
  subnets         = lookup(each.value, "subnets", {})
  tgw_id          = aws_ec2_transit_gateway.this.id
  enable_flow_log = lookup(each.value, "enable_flow_log", true)
  flow_log_bucket = "vpc-flow-logs-polaris"
}

module "ram" {
  for_each  = var.ram_shares
  source    = "./modules/ram_share"
  principal = each.value.principal
  # Construct map with (predictable) cidr key and (known-after-apply) subnet ARNs as value
  # Only ARNs are needed, but this make sure it works in a single apply
  subnets = zipmap(
    flatten([
      for vpc_k, subnets in var.ram_shares[each.key].resources : [
        # toset() makes sure we have the same ordering as the subnet_arns output from the VPC module
        for subnet in subnets : toset(var.vpcs[vpc_k].subnets[subnet].cidrs)
      ]
    ]),
    flatten([
      for vpc_k, subnets in var.ram_shares[each.key].resources : [
        for subnet in subnets : module.vpc[vpc_k].subnet_arns[subnet]
      ]
    ])
  )
}
