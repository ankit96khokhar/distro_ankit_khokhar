resource "aws_lambda_function" "lambda_function" {
  filename      = var.filename
  source_code_hash = var.source_code_hash
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role
  environment {
    variables = var.environment
  }
  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group
  ]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
retention_in_days = var.log_retention_days
}

