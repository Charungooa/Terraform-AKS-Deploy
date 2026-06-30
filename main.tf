# terraform code to create new github repo and then be able to configure the repo with secerets and updating secrets in the repo

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "my_repo" {
  name        = var.repo_name
  description = "A repository created by Terraform"
  visibility  = "private"
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

output "repository_url" {
  value = github_repository.my_repo.html_url
}

