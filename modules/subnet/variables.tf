variable "cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public" {
  type = bool
}

variable "tags" {
  type = map(string)
}
