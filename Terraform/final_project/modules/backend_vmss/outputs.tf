output "internal_lb_private_ip" {
  description = "Private IP address of the internal load balancer"
  value       = azurerm_lb.backend_internal_lb.frontend_ip_configuration[0].private_ip_address
}

output "postgres_connection_string" {
  description = "PostgreSQL connection details"
  value = {
    host     = azurerm_lb.backend_internal_lb.frontend_ip_configuration[0].private_ip_address
    port     = 5432
    database = var.postgres_db_name
    username = var.postgres_user
    connection_string = "postgresql://${var.postgres_user}:${var.postgres_password}@${azurerm_lb.backend_internal_lb.frontend_ip_configuration[0].private_ip_address}:5432/${var.postgres_db_name}"
  }
  sensitive = true
}

output "vmss_id" {
  description = "ID of the Backend VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.backend_vmss.id
}

output "vmss_name" {
  description = "Name of the Backend VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.backend_vmss.name
}

output "load_balancer_id" {
  description = "ID of the Internal Load Balancer"
  value       = azurerm_lb.backend_internal_lb.id
}