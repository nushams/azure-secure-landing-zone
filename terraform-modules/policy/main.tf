locals {
  policy_definition_file = csvdecode(file("/policy/definitions/def-policy-csv/policyname.csv"))
  policy_data            = { for name, file in data.local_file.definition_file : name => jsondecode(file.content) }
}

data "local_file" "definition_file" {
  for_each = { for n, v in local.policy_definition_file : n => v }
  filename = "/policy/definitions/${each.value.policy_ids}.json"
}

resource "azurerm_policy_definition" "definitions" {
  for_each     = local.policy_data

  name         = "def-${each.value.metadata.slug}"
  policy_type  = "Custom"
  mode         = each.value.mode
  display_name = each.value.displayName
  description  = each.value.description
  metadata     = jsonencode(each.value.metadata)
  policy_rule  = jsonencode(each.value.policyRule)
  parameters   = contains(keys(each.value), "parameters") ? jsonencode(each.value.parameters) : null
}

resource "azurerm_subscription_policy_assignment" "assignments" {
  for_each             = local.policy_data

  name                 = "ini-${each.value.metadata.slug}"
  description          = each.value.description
  policy_definition_id = azurerm_policy_definition.definitions[each.key].id
  subscription_id      = "/subscriptions/${var.subscription_id}"
}
