output "vmss_id" {
  description = "ID of the created VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.main.id
}

output "vmss_name" {
  description = "Name of the created VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.main.name
}