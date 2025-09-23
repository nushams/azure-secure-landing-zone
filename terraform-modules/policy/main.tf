# resource "azurerm_policy_definition" "tagpolicy" {
#   for_each = { for k, v in var.policy_definition : k => v }

#   name         = each.value.metadata.slug
#   policy_type  = "Custom"
#   mode         = each.value.mode
#   display_name = each.value.displayName
#   description  = each.value.description
#   metadata     = jsonencode(each.value.metadata)
#   policy_rule  = jsonencode(each.value.policyRule)
#   parameters   = contains(keys(each.value), "parameters") ? jsonencode(each.value.parameters) : null
# }

resource "azurerm_policy_definition" "locationpolicy" {
  name         = "allowedlocations"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Allowed locations"
  description  = "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region."

  metadata = <<METADATA
    {
    "version": "1.0.0",
    "category": "General"
    }

  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "location",
            "notIn": "[parameters('listOfAllowedLocations')]"
          },
          {
            "field": "location",
            "notEquals": "global"
          },
          {
            "field": "type",
            "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
  POLICY_RULE


  parameters = <<PARAMETERS
  {
      "listOfAllowedLocations": {
        "type": "Array",
        "metadata": {
          "description": "The list of locations that can be specified when deploying resources.",
          "strongType": "location",
          "displayName": "Allowed locations"
        }
      }
    }  
  PARAMETERS
}

resource "azurerm_policy_definition" "tagpolicy" {
  name         = "mandatory-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Mandatory Tags for Resource Groups"
  description  = "This policy ensures that all Resource Groups have an 'env' tag with allowed values."

  metadata = <<METADATA
{
  "category": "General",
  "slug": "mandatory-tags"
}
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions/resourceGroups"
      },
      {
        "not": {
          "field": "tags['env']",
          "in": "[parameters('env')]"
        }
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "env": {
    "type": "Array",
    "metadata": {
      "displayName": "Environment",
      "description": "List of allowed environment tags"
    },
    "defaultValue": [
      "dev"
    ],
    "allowedValues": [
      "dev",
      "prod",
      "test",
      "onprem"
    ]
  }
}
PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "locationpolicy" {
  name                 = "allowed-locations-policy-assignment"
  description          = "Policy Assignment created for Allowed Locations"
  policy_definition_id = azurerm_policy_definition.locationpolicy.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
  parameters = jsonencode({
    "listOfAllowedLocations" : {
      "value" : var.allowed_locations,
    }
    }
  )
}

resource "azurerm_subscription_policy_assignment" "tagpolicy" {
  name                 = "tag-policy-assignment"
  description          = "Policy Assignment for Tags"
  policy_definition_id = azurerm_policy_definition.tagpolicy.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_subscription_policy_assignment" "allowedvmsku" {
  name                 = "enforce-allowed-vm-sku"
  description          = "Enforce list of allowed Virtual Machine SKUs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  subscription_id      = "/subscriptions/${var.subscription_id}"

  parameters = jsonencode({
    "listOfAllowedSKUs" : {
      "value" : [
        "Standart_A2",
        "Standart_A4",
        "Standart_D2",
        "Standart_D4",
        "Standart_G2",
      ]
    }
  })
}
