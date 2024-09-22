#Use if you need VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "assignment"
  cidr = var.vpc_cidr

  azs = var.azs
  private_subnets = var.private_subnets_cidr
  public_subnets = var.public_subnets_cidr

  enable_nat_gateway = true
  enable_vpn_gateway = true


  tags = {
    project = var.project
  }
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "lambda_code/"
  output_path = "lambda_code/lambda.zip"
}

module "lambda_create" {
  source = "./modules/lambda"

  filename      = "lambda_code/lambda.zip"
  lambda_function_names = ["CreateFunction", "ReadFunction", "UpdateFunction", "DeleteFunction"]
  role          = module.iam.lambda_role_arn
  handlers       = ["create_function.lambda_handler","read_function.lambda_handler","update_function.lambda_handler","delete_function.lambda_handler"]
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_code/lambda.zip")
  environment = {
    DYNAMODB_TABLE  = module.dynamoDB.dynamodb_table_name
  }
}


#API gateways

module "api_gateways" {
  source = "./modules/api_gateway"

  # Input variables
  name        = "assignment"
  paths                = ["create", "read", "update", "delete"]
  http_methods         = ["POST", "GET", "PUT", "DELETE"]
  lambda_function_names = ["CreateFunction", "ReadFunction", "UpdateFunction", "DeleteFunction"]
  stage_name  = "dev"
  lambda_functions = module.lambda_create.lambda_function_names
  lambda_arns = module.lambda_create.lambda_function_arns
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


