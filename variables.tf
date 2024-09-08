variable "project" {
  description = "distro assignment"
  default = "distro"
}

variable "azs" {
  description = "azs"
}

variable "private_subnets_cidr" {
  description = "private subnets cidr"
}

variable "public_subnets_cidr" {
  description = "public subnet cidr"
}

variable "vpc_cidr" {
  description = "vpc cidr"
}