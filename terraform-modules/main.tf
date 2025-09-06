terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "landingzonehubspoke"
    container_name       = "terraformstatefiles"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "networking" {
  source = "./networking"
}

module "aks" {
  source       = "./aks"
  az_subnet_id = module.networking.az_subnet_id
  az_rg_name   = module.networking.az_rg_name
}

module "identity" {
  source              = "./identity"
  display_name        = var.display_name
  password            = var.password
  user_principal_name = var.user_principal_name
}
