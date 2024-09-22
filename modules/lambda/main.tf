resource "aws_lambda_function" "lambda_functions" {
  count = length(var.lambda_function_names)
  filename      = var.filename
  source_code_hash = var.source_code_hash
  function_name = var.lambda_function_names[count.index]
  handler       = var.handlers[count.index]
  runtime       = var.runtime
  role          = var.role
  environment {
    variables = var.environment
  }
#  depends_on = [
#    aws_cloudwatch_log_group.lambda_log_group
#  ]
}

#resource "aws_cloudwatch_log_group" "lambda_log_group" {
#name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
#retention_in_days = var.log_retention_days
#}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  count = length(var.lambda_function_names)
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_names[count.index] #Change this to your relevant Lambda function name
  principal     = "apigateway.amazonaws.com"
}

