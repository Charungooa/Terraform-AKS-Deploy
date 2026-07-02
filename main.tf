# terraform code to create new github repo and then be able to configure the repo with secerets and updating secrets in the repo

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "my_repo" {
  name        = var.repo_name
  description = "A repository created by Terraform"
  visibility  = "private"
  auto_init   = true
}

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

resource "github_actions_secret" "azure_credentials_secret" {
  repository      = github_repository.my_repo.name
  secret_name     = "AZURE_CREDENTIALS"
  plaintext_value = var.azure_credentials
}


resource "github_repository_file" "my_file"{
    content = <<-EOT

    name: Azure credentials test workflow
on:
    workflow_dispatch:
        
jobs:
   #rewriting the workflow Job
   azure_cred_test:
           runs-on: ubuntu-latest
           steps:
               - name: Checkout Code
                 uses: actions/checkout@v2
                 
               - name: Azure Login
                 uses: Azure/login@v3
                 with:
                     creds: ${{secrets.AZURE_CREDENTIALS}}

               - name: Test Azure CLI
                 run: az account list --output table

               - name: Check Resource Groups
                 run: az group list --output table
                
                
EOT
    file = var.file_name
    branch = "main"
    repository = github_repository.my_repo.name

    depends_on = [github_repository.my_repo]

}


output "repository_url" {
  value = github_repository.my_repo.html_url
}
