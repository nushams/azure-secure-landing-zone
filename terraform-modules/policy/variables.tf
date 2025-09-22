# variable "policy_definition" {}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "allowed_locations" {
  type        = list(any)
  description = "List of allowed Locations"
  default     = ["eastus"]
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID"
}

variable "workload_identity" {
  type        = string
  description = "AKS Workload Identity"
}

variable "keypermissionspolicy" {
  type    = list(string)
  default = ["Create", "Get", "Delete", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"]
}
