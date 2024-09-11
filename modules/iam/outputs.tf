output "lambda_role_arn" {
  description = "The ARN of the IAM role assumed by Lambda"
  value       = aws_iam_role.lambda_role.arn
}
