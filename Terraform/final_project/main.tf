terraform {
  
  }

provider "azurerm" {
  features {}
}



module "networking" {
  source = "./modules/networking"  
  
  resource_group_name       = var.resource_group_name
  location                 = var.location
  frontend_vnet_name       = var.frontend_vnet_name
  backend_vnet_name        = var.backend_vnet_name
  frontend_address_space   = var.frontend_address_space
  backend_address_space    = var.backend_address_space
  frontend_subnet_prefix   = var.frontend_subnet_prefix
  backend_subnet_prefix    = var.backend_subnet_prefix
}

module "vmss_frontend" {
  source = "./modules/frontend_vmss"
  
  resource_group_name = var.resource_group_name
  location           = var.location
  admin_password     = "Helloworld123"
  vnet_name          = var.frontend_vnet_name
  subnet_name        = var.frontend_subnet_name
  vmss_instance_count = 2

  depends_on = [module.networking]
}

module "vmss_backend" {
  source = "./modules/backend_vmss"
  
  resource_group_name     = var.resource_group_name
  location               =  var.location
  admin_password         = "Helloworld123"
  postgres_password      = "Helloworld123"
  vnet_name              = var.backend_vnet_name
  subnet_name            = var.backend_subnet_name
  frontend_subnet_cidr   = "10.1.0.0/16"  # Frontend subnet CIDR for security
  vmss_instance_count    = 2
  internal_lb_private_ip = "10.2.0.100"   # Static private IP for internal LB

  depends_on = [module.networking]
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source             = "./modules/key_vault"
  resource_group_name = var.resource_group_name
  location           = var.location
  key_vault_name     = var.key_vault_name
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_name        = var.secret_name
}

