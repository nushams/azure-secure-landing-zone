terraform {
  required_version = ">=1.7.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_role_definition" "owner" {
  name = "Owner"
}

resource "time_static" "ts" {}

resource "azuread_user" "user" {
  display_name        = var.display_name
  password            = var.password
  user_principal_name = var.user_principal_name
}

resource "azuread_group" "platform_admins" {
  display_name     = "platform_admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    azuread_user.user.object_id,
    # more users 
  ]
}

resource "azurerm_role_assignment" "sp-tenant-global-admin-user-access-role-assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = data.azurerm_role_definition.owner.name
  principal_id         = azuread_group.platform_admins.id
}

resource "azurerm_pim_active_role_assignment" "pim" {
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_id = "/subscriptions/${var.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = data.azurerm_client_config.current.object_id

  schedule {
    start_date_time = time_static.ts.rfc3339
    expiration {
      duration_hours = 8
    }
  }

  justification = "Expiration Duration Set"

  ticket {
    number = "1"
    system = "Ticket system"
  }
}
