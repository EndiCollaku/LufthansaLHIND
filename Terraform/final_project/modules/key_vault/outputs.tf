output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "secret_value" {
  description = "Generated password"
  value       = random_password.vmss_password.result
  sensitive   = true
}

output "secret_name" {
  description = "Name of the password secret"
  value       = azurerm_key_vault_secret.vmss_password_secret.name
}