resource "aws_ram_resource_share" "this" {
  name                      = var.principal
  allow_external_principals = false
}

resource "aws_ram_principal_association" "this" {
  principal          = var.principal
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_resource_association" "this" {
  for_each           = var.subnets
  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
