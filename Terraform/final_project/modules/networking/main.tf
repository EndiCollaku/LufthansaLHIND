data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Frontend Virtual Network
resource "azurerm_virtual_network" "frontend" {
  name                = var.frontend_vnet_name
  address_space       = var.frontend_address_space
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    Environment = "Development"
    Purpose     = "Frontend Network"
  }
}

# Backend Virtual Network
resource "azurerm_virtual_network" "backend" {
  name                = var.backend_vnet_name
  address_space       = var.backend_address_space
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    Environment = "Development"
    Purpose     = "Backend Network"
  }
}

# Frontend Subnet
resource "azurerm_subnet" "frontend" {
  name                 = var.frontend_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.frontend.name
  address_prefixes     = [var.frontend_subnet_prefix]
}

# Backend Subnet
resource "azurerm_subnet" "backend" {
  name                 = var.backend_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.backend.name
  address_prefixes     = [var.backend_subnet_prefix]
}

# VNet Peering: Frontend to Backend
resource "azurerm_virtual_network_peering" "frontend_to_backend" {
  name                = "peer-${var.frontend_vnet_name}-to-${var.backend_vnet_name}"
  resource_group_name = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.frontend.name
  remote_virtual_network_id = azurerm_virtual_network.backend.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# VNet Peering: Backend to Frontend
resource "azurerm_virtual_network_peering" "backend_to_frontend" {
  name                = "peer-${var.backend_vnet_name}-to-${var.frontend_vnet_name}"
  resource_group_name = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.backend.name
  remote_virtual_network_id = azurerm_virtual_network.frontend.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

