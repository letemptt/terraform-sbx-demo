# Azure Virtual Network Module
# This module creates a virtual network with a /21 address space


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_prefix]
  
  tags = var.tags
}

# Create a default subnet that uses half of the address space
resource "azurerm_subnet" "default" {
  name                 = "${var.prefix}-default-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 1, 0)]  # Use first half of the CIDR space
  
  # Optional: Configure service endpoints
  service_endpoints = var.subnet_service_endpoints
}

# Create a second subnet for special purposes (like private endpoints)
resource "azurerm_subnet" "special" {
  name                 = "${var.prefix}-special-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 1, 1)]  # Use second half of the CIDR space
  
  # Configure private link service network policies
  private_link_service_network_policies_enabled = true
  
  # Optional: Configure service endpoints
  service_endpoints = var.subnet_service_endpoints
}

# NSG for the default subnet
resource "azurerm_network_security_group" "default_nsg" {
  name                = "${var.prefix}-default-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  
  # Example security rule - allow HTTP
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  # Example security rule - allow HTTPS
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = var.tags
}

# Associate the NSG with the default subnet
resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default_nsg.id
}



# Outputs from the module
output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the created virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "default_subnet_id" {
  description = "ID of the default subnet"
  value       = azurerm_subnet.default.id
}

output "special_subnet_id" {
  description = "ID of the special subnet for private endpoints"
  value       = azurerm_subnet.special.id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.default_nsg.id
}