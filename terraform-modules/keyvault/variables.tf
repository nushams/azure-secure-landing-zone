variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "az_rg_name" {
  type        = string
  description = "Target Resource Group name"
}

variable "location" {
  type        = string
  description = "Location of the network"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID"
}

variable "workload_identity" {
  type        = string
  description = "AKS Workload Identity"
}

variable "keypermissionspolicy" {
  type        = list(string)
  description = "Key Permissions Policy list"
  default     = ["Create", "Get", "Delete", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"]
}

variable "secretpermissionspolicy" {
  type        = list(string)
  description = "Secret Permissions Policy list"
  default     = ["Set", "Get", "Delete", "Purge", "Recover", "List"]
}
