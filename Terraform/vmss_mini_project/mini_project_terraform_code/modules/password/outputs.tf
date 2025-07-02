output "admin_password" {
  description = "Generated admin password"
  value       = random_password.admin_password.result
  sensitive   = true
}

output "password_secret_id" {
  description = "ID of the password secret in Key Vault"
  value       = azurerm_key_vault_secret.admin_password.id
}