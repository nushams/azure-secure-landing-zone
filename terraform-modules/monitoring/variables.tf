variable "az_rg_name" {
  type        = string
  description = "Target Resource Group name"
}

variable "location" {
  type        = string
  description = "Target location"
}

variable "cluster_id" {
  type        = string
  description = "AKS cluster ID"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
}
