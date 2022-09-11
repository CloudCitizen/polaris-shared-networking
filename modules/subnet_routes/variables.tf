variable "nat_gateway_ids" {
  type = list(string)
}

variable "internet_gateway_id" {
  type = string
}

variable "public_subnet" {
  type = bool
}

variable "azs" {
  type = list(string)
}

variable "cidr_route_table_mapping" {
  type = map(string)
}

variable "cidrs" {
  type = list(string)
}

variable "tgw_id" {
  type = string
}

# Relying on the existence of an internet gateway for deciding on whether a public subnet exists
# results in an inability for Terraform to generate a plan, without first deploying the
# internet gateway in a separate plan (i.e. -target ..)
variable "vpc_has_public_subnet" {
  type = bool
}

variable "allow_outbound_access" {
  type = bool
}
