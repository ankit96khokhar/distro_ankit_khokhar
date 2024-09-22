output "lambda_function_arns" {
#  value = [for lambda_function in aws_lambda_function.lambda_function : lambda_function.arn]
  value = [ for lambda_function in aws_lambda_function.lambda_functions:
            lambda_function.arn]
}

output "lambda_function_names" {
  value = [for lambda_function in aws_lambda_function.lambda_functions:
            lambda_function.function_name]
}