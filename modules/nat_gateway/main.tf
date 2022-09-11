# We use count instead of for_each here to preserve list ordering
# which is needed for consistent mapping (to for example AZs)

resource "aws_eip" "nat" {
  count = length(var.subnet_ids)
  vpc   = true

  tags = {
    "Name" = format(
      "eip-nat-${var.vpc_name}-${var.name}-%s",
      element(var.azs, count.index)
    )
  }
}

resource "aws_nat_gateway" "this" {
  count = length(var.subnet_ids)

  allocation_id = aws_eip.nat[count.index].allocation_id
  subnet_id     = element(var.subnet_ids, count.index)

  tags = {
    "Name" = format(
      "nat-${var.vpc_name}-${var.name}-%s",
      element(var.azs, count.index)
    )
  }
}
