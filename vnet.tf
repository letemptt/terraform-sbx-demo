# Azure Virtual Network Module
# This module creates a virtual network with a /21 address space


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_prefix]
  
  tags = var.tags
}

# Create a default subnet with 512 IPs (using a /23 subnet)
resource "azurerm_subnet" "default" {
  name                 = "${var.prefix}-default-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 2, 0)]  # Use first quarter of the CIDR space (512 IPs)
  
  # Optional: Configure service endpoints
  service_endpoints = var.subnet_service_endpoints
}

# Create a second subnet for special purposes (like private endpoints) with 512 IPs
resource "azurerm_subnet" "special" {
  name                 = "${var.prefix}-special-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 2, 1)]  # Use second quarter of the CIDR space (512 IPs)
  
  # Configure private link service network policies
  private_link_service_network_policies_enabled = true
  
  # Optional: Configure service endpoints
  service_endpoints = var.subnet_service_endpoints
}

# Create a dedicated subnet for Cosmos DB (using a portion of the address space)
resource "azurerm_subnet" "cosmos_subnet" {
  name                 = "${var.prefix}-cosmos-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  # Use a /23 subnet from the /21 address space (dividing into 4 equal parts)
  # This gives us a subnet with 512 IP addresses
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 2, 2)]  # Use the third quarter of the CIDR space
  
  # Configure private link service and endpoint policies
  private_link_service_network_policies_enabled = false
  
  # Enable service endpoints for Azure Cosmos DB
  service_endpoints    = ["Microsoft.AzureCosmosDB"]
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

output "cosmos_subnet_id" {
  description = "ID of the dedicated subnet for Cosmos DB"
  value       = azurerm_subnet.cosmos_subnet.id
}

output "cosmos_subnet_name" {
  description = "Name of the Cosmos DB subnet"
  value       = azurerm_subnet.cosmos_subnet.name
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.default_nsg.id
}