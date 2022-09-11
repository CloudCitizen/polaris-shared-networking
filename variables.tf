variable "region" {
  default = "eu-central-1"
}

variable "global_tags" {
  type = map(string)
}

variable "platform_domain" {
  description = "Domain name for Platform Applications"
  type        = string
}

variable "vpcs" {
  description = "Map of VPCs to be created"
}

variable "vpc_endpoint_vpc" {
  description = "VPC where the VPC endpoints will be created"
  type        = string
}

variable "vpc_endpoint_subnet" {
  description = "Subnet where the VPC endpoints will be created"
  type        = string
}

variable "vpc_endpoint_default_sg_ingress_rules" {
  description = "List of security group rules for VPC endpoints"
}

variable "vpc_endpoints" {
  description = "Map of VPC endpoints to create"
  type = map(object({
    service                = optional(string)
    service_type           = optional(string)
    service_name           = optional(string)
    base_endpoint_dns_name = optional(string)
  }))
}

variable "ram_shares" {
  description = "Map of RAM shares"
  default     = {}
  type = map(object({
    principal = number
    resources = map(list(string))
  }))
}
