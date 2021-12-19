terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = var.token # or `GITHUB_TOKEN`
}
  

# Import the state from phase 1 and read the outputs
data "terraform_remote_state" "phase1" {
  backend = "s3"
  config = {
    bucket = "bucket-test-gh"
    region = "us-east-1"
    key = "p1.tfstate"
  }
}

resource "github_actions_organization_secret" "instance_id_secret" {
  repository       = "create-secret-terraform"
  secret_name      = "INSTANCE_ID"
  plaintext_value  = data.terraform_remote_state.phase1.outputs.backend_instance_id
}

resource "github_actions_organization_secret" "prod_backend_secret" {
  repository       = "create-secret-terraform"
  secret_name      = "URL_API_PROD"
  plaintext_value  = data.terraform_remote_state.phase1.outputs.backend_prod_adress
}

resource "github_actions_organization_secret" "staging_backend_secret" {
  repository       = "create-secret-terraform"
  secret_name      = "URL_API_DEV"
  plaintext_value  = data.terraform_remote_state.phase1.outputs.backend_staging_adress
}

resource "github_actions_organization_secret" "db_adress_secret" {
  repository       = "create-secret-terraform"
  secret_name      = "DATABASE_URL"
  plaintext_value  = data.terraform_remote_state.phase1.outputs.db_adress
}
