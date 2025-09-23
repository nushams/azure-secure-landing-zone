resource "azurerm_storage_account" "landingzonehubspoke" {
  name                     = "landingzonehubspoke"
  resource_group_name      = var.az_rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "aks_la" {
  name                = "aks-la"
  location            = var.location
  resource_group_name = var.az_rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "enable_logs" {
  name               = "enable-logs-in-blob"
  target_resource_id = "${azurerm_storage_account.landingzonehubspoke.id}/blobServices/default/"
  storage_account_id = azurerm_storage_account.landingzonehubspoke.id

  enabled_log {
    category = "StorageWrite"
  }
}

resource "azurerm_monitor_diagnostic_setting" "aks_diag" {
  name                       = "aks-diagnostics"
  target_resource_id         = var.cluster_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_la.id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  enabled_log {
    category = "guard"
  }

  enabled_log {
    category = "cloud-controller-manager"
  }

  enabled_log {
    category = "csi-azuredisk-controller"
  }

  enabled_log {
    category = "csi-azurefile-controller"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
