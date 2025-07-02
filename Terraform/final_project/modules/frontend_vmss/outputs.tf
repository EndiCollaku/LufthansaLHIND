output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.lb_public_ip.ip_address
}

output "load_balancer_fqdn" {
  description = "FQDN of the load balancer"
  value       = azurerm_public_ip.lb_public_ip.fqdn
}

output "vmss_id" {
  description = "ID of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.frontend_vmss.id
}

output "vmss_name" {
  description = "Name of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.frontend_vmss.name
}

output "load_balancer_id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.frontend_lb.id
}
