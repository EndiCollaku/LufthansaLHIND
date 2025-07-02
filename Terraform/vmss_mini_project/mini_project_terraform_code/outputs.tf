output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "admin_username" {
  description = "Admin username for VMSS"
  value       = "endi"
}

output "vmss_names" {
  description = "Names of created VMSS instances"
  value       = [for vmss in module.linux_vmss : vmss.vmss_name]
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = module.networking.subnet_name
}