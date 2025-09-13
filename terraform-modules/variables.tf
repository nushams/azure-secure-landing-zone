variable "display_name" {
  type        = string
  description = "User display name"
}

variable "location" {
  type        = string
  description = "Default location"
}

variable "password" {
  type        = string
  description = "User's password"
  sensitive   = true
}

variable "user_principal_name" {
  type        = string
  description = "User principal name"
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "General"
}

variable "allowed_locations" {
  type        = list(any)
  description = "List of allowed Locations"
  default     = ["eastus"]
}

variable "assign_name" {
  type        = string
  description = "Name of the Assignment"
  default     = "Allowed Locations"
}

# variable "managed_identity" {
#   type        = string
#   description = "Managed Identity ID"
# }

# variable "key_vault_id" {
#   type        = string
#   description = "Key Vault ID"
# }

# variable "keypermissionspolicy" {
#   type        = list(any)
#   description = "Key Vault permission actions"
# }
