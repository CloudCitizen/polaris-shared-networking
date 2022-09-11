output "vpc_ids" {
  value = jsonencode({
    for vpc_k in keys(var.vpcs) :
    vpc_k => module.vpc[vpc_k].vpc_id
  })
}

output "subnet_ids" {
  value = jsonencode({
    for vpc_k in keys(var.vpcs) :
    vpc_k => {
      for subnet_k, subnet_v in module.vpc[vpc_k].subnet_ids :
      # Skip "tgw" subnets as we don't need those elsewhere
      # and the amount of characters we can use (in SSM) is limited
      subnet_k => subnet_v if subnet_k != "tgw"
    }
  })
}

output "subnet_cidrs" {
  value = jsonencode({
    for vpc_k in keys(var.vpcs) :
    vpc_k => {
      for subnet_k, subnet_v in var.vpcs[vpc_k]["subnets"] :
      # Skip "tgw" subnets as we don't need those elsewhere
      # and the amount of characters we can use (in SSM) is limited
      subnet_k => subnet_v["cidrs"] if subnet_k != "tgw"
    }
  })
}
