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
  type        = string
  description = "Azure subscription ID"
}

variable "client_id" {
  type        = string
  description = "Azure Client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "General"
}

variable "assign_name" {
  type        = string
  description = "Name of the Assignment"
  default     = "Allowed Locations"
}

variable "cluster_id" {
  type        = string
  description = "AKS cluster ID"
}

variable "private_dns_zone_name" {
  type        = string
  description = "DNS Zone name"
}
