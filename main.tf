# Terraform: create a GitHub repo and configure Actions secrets
# (including Azure SP secrets used by AKS deploy workflows)

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_storage_state"
    storage_account_name = "terraformstorage82"
    container_name       = "terraformtfstate"
    key                  = "terraformaksdeploy.tfstate"
  }

  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

resource "github_repository" "my_repo" {
  name        = var.repo_name
  description = "A repository created by Terraform"
  visibility  = "private"
  auto_init   = true
}

# ---------------------------------------------------------------------------
# Optional generic secrets (legacy inputs)
# ---------------------------------------------------------------------------

resource "github_actions_secret" "my_secret" {
  repository      = github_repository.my_repo.name
  secret_name     = var.secret_name
  plaintext_value = var.secret_value
}

resource "github_actions_secret" "update_secret" {
  repository      = github_repository.my_repo.name
  secret_name     = var.second_secret_name
  plaintext_value = var.new_secret_value
}

# ---------------------------------------------------------------------------
# Azure secrets — names match GitHub repo secrets UI
#   AZURE_CLIENT_ID
#   AZURE_CLIENT_OBJECT_ID
#   AZURE_CLIENT_SECRET
#   AZURE_TENANT_ID
#   (+ AZURE_CREDENTIALS, AZURE_SUBSCRIPTION_ID when provided)
# ---------------------------------------------------------------------------

resource "github_actions_secret" "azure_client_id" {
  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = var.azure_client_id
}

resource "github_actions_secret" "azure_client_object_id" {
  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_CLIENT_OBJECT_ID"
  plaintext_value = var.azure_client_object_id
}

resource "github_actions_secret" "azure_client_secret" {
  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_CLIENT_SECRET"
  plaintext_value = var.azure_client_secret
}

resource "github_actions_secret" "azure_tenant_id" {
  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = var.azure_tenant_id
}

resource "github_actions_secret" "azure_credentials_secret" {
  count = var.azure_credentials != "" ? 1 : 0

  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_CREDENTIALS"
  plaintext_value = var.azure_credentials
}

resource "github_actions_secret" "azure_subscription_id" {
  count = var.azure_subscription_id != "" ? 1 : 0

  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = var.azure_subscription_id
}

# ---------------------------------------------------------------------------
# Sample workflow that uses AZURE_CREDENTIALS (when present)
# ---------------------------------------------------------------------------

resource "github_repository_file" "my_file" {
  content = <<-EOT
name: Azure credentials test workflow
on:
    workflow_dispatch:

jobs:
   azure_cred_test:
           runs-on: ubuntu-latest
           steps:
               - name: Checkout Code
                 uses: actions/checkout@v2

               - name: Azure Login
                 uses: Azure/login@v3
                 with:
                     creds: $${{secrets.AZURE_CREDENTIALS}}

               - name: Test Azure CLI
                 run: az account list --output table

               - name: Check Resource Groups
                 run: az group list --output table
EOT
  file       = var.file_name
  branch     = "main"
  repository = github_repository.my_repo.name

  depends_on = [github_repository.my_repo]
}

output "repository_url" {
  value = github_repository.my_repo.html_url
}

output "azure_secrets_created" {
  value = [
    "AZURE_CLIENT_ID",
    "AZURE_CLIENT_OBJECT_ID",
    "AZURE_CLIENT_SECRET",
    "AZURE_TENANT_ID",
  ]
}
