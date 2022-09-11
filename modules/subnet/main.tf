resource "aws_subnet" "this" {
  for_each = toset(var.cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  availability_zone       = element(var.azs, index(var.cidrs, each.key))
  map_public_ip_on_launch = var.public

  tags = merge({
    "Name" = format(
      "sn-${var.vpc_name}-${var.name}-%s",
      element(var.azs, index(var.cidrs, each.key)),
    )
  }, var.tags)
}

resource "aws_route_table" "this" {
  for_each = toset(var.cidrs)

  vpc_id = var.vpc_id

  tags = {
    "Name" = format(
      "rtb-${var.vpc_name}-${var.name}-%s",
      element(var.azs, index(var.cidrs, each.key))
    )
  }
}

resource "aws_route_table_association" "this" {
  for_each       = toset(var.cidrs)
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.key].id
}
