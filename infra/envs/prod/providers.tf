terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.region

  access_key = var.offline_mode ? "mock_access_key" : null
  secret_key = var.offline_mode ? "mock_secret_key" : null

  skip_credentials_validation = var.offline_mode
  skip_region_validation      = var.offline_mode
  skip_requesting_account_id  = var.offline_mode
  skip_metadata_api_check     = var.offline_mode

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Triphoria-Assessment"
    }
  }
}
