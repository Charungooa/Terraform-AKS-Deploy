variable "repo_name" {
  description = "The name of the GitHub repository to create"
  type        = string
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
  sensitive   = true
}

variable "new_secret_value" {
  description = "Value for the second generic secret"
  type        = string
  default     = "my-new-secret-value"
  sensitive   = true
}

variable "github_token" {
  description = "GitHub token with permissions to create repositories and secrets (maps from GH_TOKEN)"
  type        = string
  sensitive   = true
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
  description = "Azure authentication credentials JSON for Service Principal (secret name AZURE_CREDENTIALS)"
  type        = string
  default     = ""
  sensitive   = true
}

# ---------------------------------------------------------------------------
# Azure secrets (match GitHub Actions secret names circled in the UI)
# Source secrets: AZURE_CLIENT_ID, AZURE_CLIENT_OBJECT_ID,
#                 AZURE_CLIENT_SECRET, AZURE_TENANT_ID
# ---------------------------------------------------------------------------

variable "azure_client_id" {
  description = "Azure Service Principal Application (client) ID — GitHub secret AZURE_CLIENT_ID"
  type        = string
  sensitive   = true
}

variable "azure_client_object_id" {
  description = "Azure Service Principal Object ID — GitHub secret AZURE_CLIENT_OBJECT_ID"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure Service Principal client secret — GitHub secret AZURE_CLIENT_SECRET"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure Active Directory tenant ID — GitHub secret AZURE_TENANT_ID"
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure subscription ID — GitHub secret AZURE_SUBSCRIPTION_ID (optional companion secret)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "file_name" {
  description = "The name of the workflow file to create in the GitHub repository"
  type        = string
  default     = ".github/workflows/azure_credentials_test_workflow.yaml"
}
