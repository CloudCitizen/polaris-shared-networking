locals {}

inputs = {
  global_tags = {
    Project   = "Polaris"
    Owner     = "platform"
    CreatedBy = "terraform"
    ManagedBy = "repo/${basename(get_terragrunt_dir())}"
  }
}

remote_state {
  backend = "s3"

  config = {
    region                  = "eu-west-1"
    encrypt                 = true
    dynamodb_table          = "tflock-shared-networking"
    bucket                  = "tfstate-shared-networking"
    key                     = "${get_aws_account_id()}/${basename(get_terragrunt_dir())}/${path_relative_to_include()}/terraform.tfstate"
    skip_metadata_api_check = true
    skip_bucket_versioning  = true
    disable_bucket_update   = true
  }
}
