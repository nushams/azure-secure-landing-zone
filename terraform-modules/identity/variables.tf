variable "display_name" {
  type        = string
  description = "User display name"
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
