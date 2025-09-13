output "policy_definition_ids" {
  value = { for k, v in azurerm_policy_definition.tagpolicy : jsondecode(v.metadata).slug => v.id }
}
