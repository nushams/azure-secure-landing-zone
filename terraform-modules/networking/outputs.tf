output "az_rg_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.spoke1-vnet-rg.id
}

output "az_rg_name" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.spoke1-vnet-rg.name
}

output "az_vnet_id" {
  description = "The ID of the vnet"
  value       = azurerm_virtual_network.spoke1-vnet.id
}

output "az_subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.spoke1-aks.id
}
