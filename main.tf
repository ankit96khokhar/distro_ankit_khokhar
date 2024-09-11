#Use if you need VPC
#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "5.13.0"
#
#  name = "assignment"
#  cidr = var.vpc_cidr
#
#  azs = var.azs
#  private_subnets = var.private_subnets_cidr
#  public_subnets = var.public_subnets_cidr
#
#  enable_nat_gateway = true
#  enable_vpn_gateway = true
#
#
#  tags = {
#    project = var.project
#  }
#}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "lambda_code/"
  output_path = "lambda_code/lambda.zip"
}

module "lambda_create" {
  source = "./modules/lambda"

  filename      = "lambda_code/lambda.zip"
  function_name = "CreateFunction"
  role          = module.iam.lambda_role_arn
  handler       = "create_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_code/lambda.zip")
  environment = {
    DYNAMODB_TABLE  = module.dynamoDB.dynamodb_table_name
  }
}

module "lambda_read" {
  source = "./modules/lambda"

  filename      = "lambda_code/lambda.zip"
  function_name = "ReadFunction"
  role          = module.iam.lambda_role_arn
  handler       = "read_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_code/lambda.zip")
  environment = {
    DYNAMODB_TABLE  = module.dynamoDB.dynamodb_table_name
  }
}

module "lambda_update" {
  source = "./modules/lambda"

  filename      = "lambda_code/lambda.zip"
  function_name = "UpdateFunction"
  role          = module.iam.lambda_role_arn
  handler       = "update_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_code/lambda.zip")
  environment = {
    DYNAMODB_TABLE  = module.dynamoDB.dynamodb_table_name
  }
}

module "lambda_delete" {
  source = "./modules/lambda"

  filename      = "lambda_code/lambda.zip"
  function_name = "DeleteFunction"
  role          = module.iam.lambda_role_arn
  handler       = "delete_function.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_code/lambda.zip")
  environment = {
    DYNAMODB_TABLE  = module.dynamoDB.dynamodb_table_name
  }
}


#API gateways

module "api_gateway_create" {
  source = "./modules/api_gateway"

  # Input variables
  name        = "create"
  stage_name  = "dev"
  method      = "GET"
  lambda      = module.lambda_create.lambda_function_name
  lambda_arn  = module.lambda_create.lambda_function_arn
  region      = var.region
  account_id  = var.accountId
  burst_limit = var.burst_limit
  rate_limit = var.rate_limit
  quota_limit = var.quota_limit
}

module "api_gateway_read" {
  source = "./modules/api_gateway"

  # Input variables
  name        = "read"
  stage_name  = "dev"
  method      = "GET"
  lambda      = module.lambda_read.lambda_function_name
  lambda_arn  = module.lambda_read.lambda_function_arn
  region      = var.region
  account_id  = var.accountId
  burst_limit = var.burst_limit
  rate_limit = var.rate_limit
  quota_limit = var.quota_limit
}


module "api_gateway_update" {
  source = "./modules/api_gateway"

  # Input variables
  name        = "update"
  stage_name  = "dev"
  method      = "GET"
  lambda      = module.lambda_update.lambda_function_name
  lambda_arn  = module.lambda_update.lambda_function_arn
  region      = var.region
  account_id  = var.accountId
  burst_limit = var.burst_limit
  rate_limit = var.rate_limit
  quota_limit = var.quota_limit
}

module "api_gateway_delete" {
  source = "./modules/api_gateway"

  # Input variables
  name        = "delete"
  stage_name  = "dev"
  method      = "GET"
  lambda      = module.lambda_delete.lambda_function_name
  lambda_arn  = module.lambda_delete.lambda_function_arn
  region      = var.region
  account_id  = var.accountId
  burst_limit = var.burst_limit
  rate_limit = var.rate_limit
  quota_limit = var.quota_limit
}



#DynamoDB
module "dynamoDB" {
  source = "./modules/dynamoDB"

  dynamodb_table_name = "store_lambda_output"
}

module "iam" {
  source            = "./modules/iam"
  role_name         = "LambdaDynamoDBRole"
  dynamodb_table_arn = module.dynamoDB.dynamodb_table_arn
}
