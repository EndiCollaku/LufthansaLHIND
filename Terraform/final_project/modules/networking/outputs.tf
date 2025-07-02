# networking/outputs.tf

output "frontend_vnet_name" {
  description = "Name of the frontend virtual network"
  value       = azurerm_virtual_network.frontend.name
}

output "backend_vnet_name" {
  description = "Name of the backend virtual network"
  value       = azurerm_virtual_network.backend.name
}

output "frontend_vnet_id" {
  description = "ID of the frontend virtual network"
  value       = azurerm_virtual_network.frontend.id
}

output "backend_vnet_id" {
  description = "ID of the backend virtual network"
  value       = azurerm_virtual_network.backend.id
}

output "frontend_subnet_name" {
  description = "Name of the frontend subnet"
  value       = azurerm_subnet.frontend.name
}

output "backend_subnet_name" {
  description = "Name of the backend subnet"
  value       = azurerm_subnet.backend.name
}

output "frontend_subnet_id" {
  description = "ID of the frontend subnet"
  value       = azurerm_subnet.frontend.id
}

output "backend_subnet_id" {
  description = "ID of the backend subnet"
  value       = azurerm_subnet.backend.id
}

output "frontend_subnet_cidr" {
  description = "CIDR of the frontend subnet"
  value       = var.frontend_subnet_prefix
}

output "backend_subnet_cidr" {
  description = "CIDR of the backend subnet"
  value       = var.backend_subnet_prefix
}