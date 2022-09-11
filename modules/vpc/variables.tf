variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  type = map(object({
    public                = optional(bool)
    allow_outbound_access = optional(bool)
    cidrs                 = list(string)
    tags                  = optional(map(string))
  }))
}

variable "tgw_id" {
  type = string
}

variable "azs" {
  description = "A list of availability zones names"
  type        = list(string)
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
}

variable "flow_log_bucket" {
  description = "Bucket in which VPC flow logs should be stored"
  type        = string
}
