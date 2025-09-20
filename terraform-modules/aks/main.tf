data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.az_rg_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version
  node_resource_group = "aks_${var.cluster_name}_${var.location}"
  tags                = var.aks_tags

  default_node_pool {
    name                         = "system"
    type                         = "VirtualMachineScaleSets"
    node_count                   = 1
    vm_size                      = "standard_a2_v2"
    vnet_subnet_id               = var.az_subnet_id
    only_critical_addons_enabled = true

    node_labels = {
      "worker-name" = "system"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  private_cluster_enabled = true

  network_profile {
    network_plugin = var.network_plugin
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
}

resource "azurerm_kubernetes_cluster_node_pool" "k8s-worker" {
  for_each = var.nodepools

  name                   = each.value.name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.k8s.id
  vm_size                = each.value.vm_size
  min_count              = each.value.min_count
  max_count              = each.value.max_count
  auto_scaling_enabled   = each.value.enable_auto_scaling
  node_public_ip_enabled = each.value.enable_node_public_ip
  zones                  = each.value.zones
  vnet_subnet_id         = var.az_subnet_id
  tags                   = each.value.tags
  node_labels            = each.value.node_labels
}


resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "aksworkloadidentity"
  location            = var.location
  resource_group_name = var.az_rg_name
}

resource "azurerm_federated_identity_credential" "workload_identity" {
  name                = azurerm_user_assigned_identity.workload_identity.name
  resource_group_name = azurerm_user_assigned_identity.workload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.workload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_sa_namespace}:${var.workload_sa_name}"
}

resource "azurerm_role_assignment" "wla_aks" {
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_id = "/subscriptions/${var.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_user_assigned_identity.workload_identity.principal_id
}
