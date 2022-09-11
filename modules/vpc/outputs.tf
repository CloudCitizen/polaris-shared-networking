output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.id, "")
}

output "subnet_ids" {
  value = {
    for k, v in module.subnets :
    k => v.subnet_ids
  }
}

output "subnet_arns" {
  value = {
    for k, v in module.subnets :
    k => v.subnet_arns
  }
}

output "route_table_ids" {
  value = {
    for k, v in module.subnets :
    k => v.route_table_ids
  }
}

output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}
