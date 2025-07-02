data "azurerm_virtual_network" "vnet_backend" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Data source to reference existing subnet
data "azurerm_subnet" "subnet_backend" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_backend.name
  resource_group_name  = var.resource_group_name
}

# Internal Load Balancer (no public IP)
resource "azurerm_lb" "backend_internal_lb" {
  name                = "lb-backend-internal"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "InternalIPAddress"
    subnet_id                     = data.azurerm_subnet.subnet_backend.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.1.100"
  }

  tags = {
    Environment = "Production"
    Module      = "vmss_backend"
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.backend_internal_lb.id
  name            = "BackEndAddressPool"
}

# Health Probe for PostgreSQL port 5432
resource "azurerm_lb_probe" "postgres_health_probe" {
  loadbalancer_id = azurerm_lb.backend_internal_lb.id
  name            = "postgres-probe"
  port            = 5432
  protocol        = "Tcp"
}

# Load Balancing Rule for PostgreSQL port 5432
resource "azurerm_lb_rule" "postgres_lb_rule" {
  loadbalancer_id                = azurerm_lb.backend_internal_lb.id
  name                           = "PostgreSQL"
  protocol                       = "Tcp"
  frontend_port                  = 5432
  backend_port                   = 5432
  frontend_ip_configuration_name = "InternalIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.postgres_health_probe.id
}

resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "pip-natgw-backend"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Production"
    Module      = "vmss_backend"
  }
}

# NAT Gateway
resource "azurerm_nat_gateway" "backend_nat_gateway" {
  name                    = "natgw-backend"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = {
    Environment = "Production"
    Module      = "vmss_backend"
  }
}

# Associate Public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "backend_nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.backend_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

# Associate NAT Gateway with the backend subnet
resource "azurerm_subnet_nat_gateway_association" "backend_subnet_nat_assoc" {
  subnet_id      = data.azurerm_subnet.subnet_backend.id
  nat_gateway_id = azurerm_nat_gateway.backend_nat_gateway.id
}

# Add these outbound rules to your existing NSG
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "vmss-backend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Existing inbound rules (keep these)
  security_rule {
    name                       = "AllowPostgreSQLFromFrontend"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = var.frontend_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSHFromBackend"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.1.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOtherInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # NEW: Outbound rules for internet access
  security_rule {
    name                       = "AllowHTTPSOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "AllowHTTPOutbound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "AllowDNSOutbound"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  # Allow NTP for time synchronization
  security_rule {
    name                       = "AllowNTPOutbound"
    priority                   = 1004
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = {
    Environment = "Production"
    Module      = "vmss_backend"
  }
}

# VM Scale Set for Backend (PostgreSQL)
resource "azurerm_linux_virtual_machine_scale_set" "backend_vmss" {
  name                = "vmss-backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = var.vmss_instance_count
  upgrade_mode        = "Automatic"

  # Use password authentication
  disable_password_authentication = false
  admin_username                  = "endi"
  admin_password                  = var.admin_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "internal"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = data.azurerm_subnet.subnet_backend.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }

    network_security_group_id = azurerm_network_security_group.backend_nsg.id
  }
}