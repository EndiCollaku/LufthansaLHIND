data "azurerm_virtual_network" "vnet_frontend" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Data source to reference existing subnet
data "azurerm_subnet" "subnet_frontend" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_frontend.name
  resource_group_name  = var.resource_group_name
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-frontend-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Production"
    Module      = "vmss_frontend"
  }
}

# Load Balancer
resource "azurerm_lb" "frontend_lb" {
  name                = "lb-frontend"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  tags = {
    Environment = "Production"
    Module      = "vmss_frontend"
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "frontend_backend_pool" {
  loadbalancer_id = azurerm_lb.frontend_lb.id
  name            = "BackEndAddressPool"
}

# Health Probe for port 80
resource "azurerm_lb_probe" "frontend_health_probe" {
  loadbalancer_id = azurerm_lb.frontend_lb.id
  name            = "http-probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

# Load Balancing Rule for port 80
resource "azurerm_lb_rule" "frontend_lb_rule" {
  loadbalancer_id                = azurerm_lb.frontend_lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.frontend_backend_pool.id]
  probe_id                       = azurerm_lb_probe.frontend_health_probe.id
  disable_outbound_snat         = true
}

# NAT Pool for SSH access to VMSS instances
resource "azurerm_lb_nat_pool" "ssh_nat_pool" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.frontend_lb.id
  name                           = "SSHNatPool"
  protocol                       = "Tcp"
  frontend_port_start            = 2200
  frontend_port_end              = 2299
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

# Network Security Group for VMSS
resource "azurerm_network_security_group" "vmss_nsg" {
  name                = "vmss-frontend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-NAT-Pool"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["2200-2299"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Production"
    Module      = "vmss_frontend"
  }
}

# VM Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "frontend_vmss" {
  name                = "vmss-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = var.vmss_instance_count
  upgrade_mode        = "Automatic"

  # Disable password authentication and use password instead of SSH key
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
      subnet_id                              = data.azurerm_subnet.subnet_frontend.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.frontend_backend_pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.ssh_nat_pool.id]
    }

    network_security_group_id = azurerm_network_security_group.vmss_nsg.id
  }

 
}

# Outbound rule for internet access (required for package installation)
resource "azurerm_lb_outbound_rule" "frontend_outbound" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.frontend_lb.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend_backend_pool.id
  
  allocated_outbound_ports = 1024
  idle_timeout_in_minutes  = 4

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
  depends_on = [
    azurerm_lb_rule.frontend_lb_rule,
    azurerm_lb_nat_pool.ssh_nat_pool,
    azurerm_lb_probe.frontend_health_probe
  ]
}