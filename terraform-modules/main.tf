terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "landingzonehubspoke"
    container_name       = "terraformstatefiles"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "networking" {
  source                = "./networking"
  subscription_id       = var.subscription_id
  password              = var.password
  private_dns_zone_name = var.private_dns_zone_name
}

module "aks" {
  source          = "./aks"
  az_subnet_id    = module.networking.az_subnet_id
  az_rg_name      = module.networking.az_rg_name
  location        = var.location
  subscription_id = var.subscription_id
  depends_on      = [module.networking]
}

module "identity" {
  source              = "./identity"
  display_name        = var.display_name
  password            = var.password
  user_principal_name = var.user_principal_name
  subscription_id     = var.subscription_id
}

# locals {
#   policy_definition_file = csvdecode(file("${path.root}/policy/definition/def-policy-csv/policyname.csv"))
#   policy_data            = { for name, file in data.local_file.definition_file : name => jsondecode(file.content) }
# }

# data "local_file" "definition_file" {
#   for_each = { for n, v in local.policy_definition_file : n => v }
#   filename = "${path.root}/policy/definition/${each.value.policy_ids}.json"
# }

module "policy_def" {
  source = "./policy"
  # policy_definition    = local.policy_data
  subscription_id      = var.subscription_id
  allowed_locations    = var.allowed_locations
  tenant_id            = var.tenant_id
  key_vault_id         = module.key_vault.key_vault_id
  workload_identity    = module.aks.workload_identity
  keypermissionspolicy = ["Get", "List", "Encrypt", "Decrypt"]
  depends_on           = [module.key_vault, module.aks]
}

module "key_vault" {
  source            = "./keyvault"
  subscription_id   = var.subscription_id
  az_rg_name        = module.networking.az_rg_name
  location          = var.location
  tenant_id         = var.tenant_id
  workload_identity = module.aks.workload_identity
  keypermissionspolicy = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "Recover",
    "Update",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
  secretpermissionspolicy = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover",
    "List"
  ]
  depends_on = [module.aks]
}

module "monitoring" {
  source          = "./monitoring"
  subscription_id = var.subscription_id
  az_rg_name      = module.networking.az_rg_name
  location        = var.location
  cluster_id      = module.aks.cluster_id
  depends_on      = [module.networking, module.aks]
}
