variable "location" {
  description = "Location of the network"
  default     = "eastus"
}

variable "hub_prefix" {
  description = "Prefix for hub reqources"
  default     = "hub"
}

variable "spoke1_prefix" {
  description = "Prefix for spoke1 reqources"
  default     = "spoke1"
}

variable "shared_key" {
  description = "Shared key for Gateway connections"
  default     = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

variable "username" {
  description = "Username for Virtual Machines"
  default     = "azureuser"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "standard_a2_v2"
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone. Must be a valid domain name. Changing this value forces a new resource to be created."
  default     = "datarises.com"
}
