# Azure Policy Definitions & Assignments

This module deploys and assigns **custom Azure Policy definitions** at the subscription scope using **Terraform**.  
Policies are defined in **JSON files** and referenced via a **CSV mapping file** for easier management.

## What's important to follow?

If you would like to add additional policies, please follow these steps below:

- Update `policyname.csv` -> Add your policy name
- Add `.json` file of a new policy, keep the same name as in the `.csv` file
- Format the `.json` according to this template (Please note, this is not a strict template, thus edit it according to individual policy):
```json
{
  "displayName": "",
  "description": "",
  "mode": "",
  "policyRule": {
    "if": {
        ...
      ]
    },
    "then": {
      "effect": ""
    }
  },
  "parameters": {
    "PARAMETER_EDIT": {
      "type": "",
      "metadata": {
        "description": "",
        "strongType": "",
        "displayName": ""
      },
      "defaultValue": [
        ""
      ],
      "allowedValues": [
        "",
        ""
      ]
    }
  },
  "metadata": {
    "version": "",
    "category": "",
    "slug": ""
  }
}
```

In case, just follow the best practices and documentation.
