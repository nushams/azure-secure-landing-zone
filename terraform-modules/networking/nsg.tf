resource "azurerm_network_security_group" "nsg-hub" {
  name                = "nsg-hub-${var.hub_prefix}-01"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  security_rule {
    name                       = "allow-aks"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "10.1.0.0/24"
    destination_address_prefix = "*"
  }

  tags = {
    env = "prod"
  }
}

resource "azurerm_network_security_group" "nsg-spoke1" {
  name                = "nsg-prod-${var.spoke1_prefix}-01"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  security_rule {
    name                       = "allow-hub-to-aks"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["10.0.0.64/27"]
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
  }

  tags = {
    env = "prod"
  }
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny-all-inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.spoke1-vnet-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-spoke1.name
}
