# # AI Services Configuration
# resource "azurerm_ai_services" "azais" {
#   name                = "${var.prefix}azais"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku_name            = "S0"  # Standard tier is required for private endpoints
  
#   # Required for private endpoint connectivity
#   custom_subdomain_name = lower("${var.prefix}aiservices")
# }

# # Private Endpoints
# resource "azurerm_private_endpoint" "ai_services_pe" {
#   name                = "${var.prefix}-aiservices-pe-${random_integer.ri.result}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.special.id  # Using the special subnet
  
#   private_service_connection {
#     name                           = "${var.prefix}-aiservices-psc-${random_integer.ri.result}"
#     private_connection_resource_id = azurerm_ai_services.azais.id
#     is_manual_connection           = false
#     subresource_names              = ["account"]
#   }
  
#   private_dns_zone_group {
#     name                 = "aiservices-dns-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.ai_services_dns.id]
#   }
# }

# # Private DNS Zones
# resource "azurerm_private_dns_zone" "ai_services_dns" {
#   name                = "privatelink.cognitiveservices.azure.com"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# # DNS Zone Links
# resource "azurerm_private_dns_zone_virtual_network_link" "ai_services_dns_link" {
#   name                  = "${var.prefix}-aiservices-dns-link-${random_integer.ri.result}"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.ai_services_dns.name
#   virtual_network_id    = azurerm_virtual_network.vnet.id
#   registration_enabled  = true
# }