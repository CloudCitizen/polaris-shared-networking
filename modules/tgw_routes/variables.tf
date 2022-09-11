variable "tgw_route_table_id" {
  type = string
}

variable "tgw_attachment_ids" {
  type = map(string)
}

variable "tgw_propagations" {
  type = list(string)
}
