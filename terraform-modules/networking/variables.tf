variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "location" {
  type        = string
  description = "Location of the network"
  default     = "eastus"
}

variable "hub_prefix" {
  type        = string
  description = "Prefix for hub reqources"
  default     = "hub"
}

variable "spoke1_prefix" {
  type        = string
  description = "Prefix for spoke1 reqources"
  default     = "spoke1"
}

variable "onprem_prefix" {
  type        = string
  description = "Prefix for onprem reqources"
  default     = "onprem"
}

variable "shared_key" {
  type        = string
  description = "Shared key for Gateway connections"
}

variable "username" {
  type        = string
  description = "Username for Virtual Machines"
  default     = "azureuser"
}

variable "vmsize" {
  type        = string
  description = "Size of the VMs"
  default     = "standard_a2_v2"
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone. Must be a valid domain name."
}

variable "password" {
  type        = string
  description = "VM password"
  sensitive   = true
}
