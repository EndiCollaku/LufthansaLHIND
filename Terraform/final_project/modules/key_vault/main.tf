data "azurerm_client_config" "current" {}

# Generate random password
resource "random_password" "vmss_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Add a random suffix to avoid naming conflicts with soft-deleted secrets
resource "random_id" "secret_suffix" {
  byte_length = 4
}

# Key Vault with proper access policy
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Enable soft delete and purge protection
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Access policy for current user/service principal
  access_policy {
    tenant_id = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id
    object_id = var.object_id != null ? var.object_id : data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }

  tags = {
    Environment = "Production"
  }
}

# Secret with unique name to avoid soft-delete conflicts
resource "azurerm_key_vault_secret" "vmss_password_secret" {
  name         = "${var.secret_name}-${random_id.secret_suffix.hex}"
  value        = random_password.vmss_password.result
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_key_vault.this]
}