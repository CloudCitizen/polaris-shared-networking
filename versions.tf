terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25"
    }
  }
  backend "s3" {}
  experiments = [module_variable_optional_attrs]
}
