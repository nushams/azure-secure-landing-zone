resource "azurerm_key_vault" "key_vault" {
  name                        = "key-vault-caf"
  location                    = var.location
  resource_group_name         = var.az_rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  sku_name                    = "standard"
  rbac_authorization_enabled  = true

  access_policy {
    tenant_id          = var.tenant_id
    object_id          = var.workload_identity
    key_permissions    = var.keypermissionspolicy
    secret_permissions = var.secretpermissionspolicy
  }
}

resource "azurerm_role_assignment" "azrbacpolicy" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.workload_identity
}
