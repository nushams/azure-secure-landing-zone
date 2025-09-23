# Azure Policy Definitions & Assignments

This document describes the **Azure Policy configurations** defined in policy module (`main.tf`).  
Policies enforce governance rules across the subscription to maintain **compliance, security, and cost controls**.

---

## Custom Policy Definitions

### 1. **Tag Policy**
- **Type:** Custom  
- **Mode:** Defined dynamically via `var.policy_definition`  
- **Description:**  
  Enforces custom tagging standards on deployed resources.  
- **Configuration:**  
  - Accepts multiple definitions from `var.policy_definition`.  
  - Each policy includes:
    - `slug` (used as the policy name)  
    - `mode` (e.g., Indexed, All)  
    - `displayName`  
    - `description`  
    - `policyRule` (logic in JSON)  
    - Optional `parameters`

---

### 2. **Allowed Locations Policy**
- **Type:** Custom  
- **Mode:** Indexed  
- **Name:** `allowedlocations`  
- **Display Name:** Allowed locations  
- **Description:**  
  Restricts resource deployment to a list of approved Azure regions.  
  Helps enforce **geo-compliance** requirements.  

- **Policy Rule Logic:**  
  - Deny if:
    - Resource `location` is **not in** the allowed list (`listOfAllowedLocations`)  
    - `location` is not `"eastus"`  
    - Resource `type` is not `Microsoft.AzureActiveDirectory/b2cDirectories`  

- **Parameters:**  
  - `listOfAllowedLocations` (Array): Defines the permitted Azure regions.

---

## Built-In Policy Assignments

### 3. **Allowed VM SKUs**
- **Policy Definition ID:**  
  `/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3`  
  *(Built-in Microsoft Policy)*

- **Display Name:** Enforce allowed Virtual Machine SKUs  
- **Description:** Restricts VM creation to a curated list of sizes for **cost control** and **standardization**.  
- **Parameters (example from code):**  
  ```json
  "listOfAllowedSKUs": {
    "value": [
      "Standart_A2",
      "Standart_A4",
      "Standart_D2",
      "Standart_D4",
      "Standart_G2"
    ]
  }

---

### 4. **Key Vault Access Policy**
- **Resource Type:** `azurerm_key_vault_access_policy`  
- **Scope:** Target Key Vault defined in `var.key_vault_id`  
- **Assignments:** 
  - Grants permissions to a Managed Identity (`var.workload_identity`)
  - Uses `var.keypermissionspolicy` for key permissions (e.g., `get`, `list`, `encrypt`, `decrypt`)
- **Purpose:** Ensures workloads (via managed identity) can securely interact with Azure Key Vault, without relying on static secrets. 
