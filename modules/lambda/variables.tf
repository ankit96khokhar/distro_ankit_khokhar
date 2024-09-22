variable "filename" {
  type        = string
}

variable "lambda_function_names" {
  type        = list(string)
}

variable "handlers" {
  type        = list(string)
}

variable "runtime" {
  type        = string
}

variable "role" {
  type        = string
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "source_code_hash" {
  description = "source_code_hash"
}

variable "log_retention_days" {
  default = 14
}