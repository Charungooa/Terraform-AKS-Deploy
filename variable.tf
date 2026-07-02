variable "repo_name" {
  description = "The name of the GitHub repository to create"
  type        = string
  #default     = "my-terraform-repo"
}

variable "secret_name" {
  description = "The name of the secret to create in the GitHub repository"
  type        = string
  default     = "my-secret"
}

variable "secret_value" {
  description = "The value of the secret to create in the GitHub repository"
  type        = string
  default     = "my-secret-value"

}

variable "new_secret_value" {
  description = "value"
  type        = string
  default     = "my-new-secret-value"
}

variable "github_token" {
  description = "GitHub token with permissions to create repositories and secrets"
  type        = string
  default     = "your-github-token-here"
}

variable "github_owner" {
  description = "The owner of the GitHub repository (username or organization)"
  type        = string
  default     = "your-github-username-or-organization"
}

variable "second_secret_name" {
  description = "The name of the second secret to create in the GitHub repository"
  type        = string
  default     = "my-second-secret"
}

variable "azure_credentials" {
  description = "consists of Azure authentication credentials for Service Principal"
  default = ""
  type = string
}

variable "file_name" {
  description = "The name of the file to create in the GitHub repository"
  default = ".github/workflows/azure_credentials_test_workflow.yaml"
  type = string
}

# variable "azure_credentials_json" {
#   description = "Azure credentials in JSON format for Service Principal"
#   default = ""
#   type = string
# }