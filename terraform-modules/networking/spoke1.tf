resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = "${var.spoke1_prefix}-rg"
  location = var.location

  tags = {
    env = "prod"
  }
}

resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "${var.spoke1_prefix}-vnet"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = var.spoke1_prefix
  }
}

resource "azurerm_subnet" "spoke1-db" {
  name                 = "database"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["10.1.0.64/27"]
}

resource "azurerm_subnet" "spoke1-aks" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}
