variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "workload_identity" {
  type        = string
  description = "AKS Workload Identity"
}

variable "keypermissionspolicy" {
  type    = list(string)
  default = ["Create", "Get", "Delete", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"]
}
