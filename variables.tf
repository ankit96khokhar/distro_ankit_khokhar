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

variable "region" {
  description = "region"
}

variable "accountId" {
  description = "account id of AWS"
}

variable "burst_limit" {
  description = "Burst limit"
  default = "100"
}

variable "rate_limit" {
  description = "Rate limit"
  default = "50"
}

variable "quota_limit" {
  description = "Quota limit"
  default = 1000
}
