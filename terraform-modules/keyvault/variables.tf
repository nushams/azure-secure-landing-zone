variable "az_rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "managed_identity" {
  type = string
}

variable "keypermissionspolicy" {
  type = list(string)
}

variable "secretpermissionspolicy" {
  type = list(string)
}
