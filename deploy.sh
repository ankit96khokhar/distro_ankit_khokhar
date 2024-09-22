#!/bin/bash

# Function to initialize and validate Terraform
initialize_and_validate() {
  echo "Initializing Terraform..."
  terraform init

  echo "Validating Terraform configuration..."
  terraform validate

  if [ $? -ne 0 ]; then
    echo "Terraform validation failed!"
    exit 1
  fi
}

# Function to apply Terraform plan
apply_terraform() {
  echo "Applying ..."
  terraform apply -auto-approve

  if [ $? -ne 0 ]; then
    echo "Terraform apply failed!"
    exit 1
  fi
}

# Function to destroy Terraform-managed infrastructure
destroy_terraform() {
  echo "Destroying  infrastructure"
  terraform destroy -auto-approve

  if [ $? -ne 0 ]; then
    echo "Terraform destroy failed"
    exit 1
  fi
}

# Main script logic
#initialize_and_validate
#apply_terraform

destroy_terraform
