terraform {
  backend "s3" {
    bucket = "remote-statefile-ankit-khokhar"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-locks"
  }
}