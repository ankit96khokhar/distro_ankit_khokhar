variable "name" {
  description = "The name of the REST API"
}

variable "stage_name" {
  description = "The stage name for the API deployment (production/staging/etc..)"
}

variable "method" {
  description = "The HTTP method"
  default     = "GET"
}

variable "lambda" {
  description = "The lambda function name to invoke"
}

variable "lambda_arn" {
  description = "The lambda arn to invoke"
}

variable "region" {
  description = "The AWS region, e.g., eu-west-1"
}

variable "account_id" {
  description = "The AWS account ID"
}

variable "burst_limit" {
  description = "Burst limit"
}

variable "rate_limit" {
  description = "Rate limit"
}

variable "quota_limit" {
  description = "Quota limit"
}
