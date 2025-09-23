terraform {
  required_version = ">=1.7.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = "${var.hub_prefix}-rg"
  location = var.location

  tags = {
    env = "prod"
  }
}

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${var.hub_prefix}-vnet"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.hub_prefix
  }
}

resource "azurerm_subnet" "hub-mgmt" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.0.64/27"]
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
}

# Private DNS Zone Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                  = "dns-vnet-link"
  resource_group_name   = azurerm_resource_group.hub-vnet-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id

  tags = {
    env = "prod"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub-mgmt.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}
