terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.69"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}

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
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = data.azurerm_role_definition.owner.name
  principal_id         = azuread_group.platform_admins.id
}

resource "azurerm_pim_active_role_assignment" "pim" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.owner.id}"
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
