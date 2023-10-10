terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  #region = YOUR-DEFAULT-REGION
  #access_key = YOUR-ACCESS-KEY
  #secret_key = YOUR-SECRET-KEY
}

variable "key_name" {
  description = "Name of the SSH key pair"
}
