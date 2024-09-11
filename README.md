# distro_ankit_khokhar

Serverless Application with AWS Lambda, API Gateway, and DynamoDB
This repository contains Terraform configurations to provision a serverless architecture using AWS Lambda functions connected to DynamoDB and exposed through API Gateway. The setup includes IAM roles and CloudWatch Log Groups.

Prerequisites
Terraform: Ensure you have Terraform installed.
AWS CLI: Ensure you have AWS CLI installed and configured with your credentials.

Components
Lambda Functions: Deploy multiple Lambda functions for create, read, update, and delete operations.
API Gateway: Set up API endpoints connected to the Lambda functions.
DynamoDB: Provision a DynamoDB table to store Lambda function outputs.
IAM Roles: Define IAM roles with necessary permissions for the Lambda functions.
Usage
Scripted Deployment
Run the provided Bash script (deploy.sh) to automate the deployment, initialization, and destruction of the infrastructure using Terraform.