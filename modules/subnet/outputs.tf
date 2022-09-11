output "subnet_ids" {
  value = [for k, v in aws_subnet.this : v.id]
}

output "subnet_arns" {
  value = [for k, v in aws_subnet.this : v.arn]
}

output "cidr_route_table_mapping" {
  value = zipmap(
    toset(var.cidrs),
    [for k, v in aws_route_table.this : v.id]
  )
}

output "route_table_ids" {
  value = [for k, v in aws_route_table.this : v.id]
}
