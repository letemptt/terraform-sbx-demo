
# # resource "random_integer" "ri" {
# #   min = 10000
# #   max = 99999
# # }

# # Use the VNet module from vnet.tf instead of referencing an existing one
# # No need for the data source anymore since we're creating the VNet in vnet.tf


# resource "azurerm_cosmosdb_account" "db" {
#   name                = "${var.prefix}db${random_integer.ri.result}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"

#   automatic_failover_enabled = true
#   public_network_access_enabled = false  # Disable public access

#   capabilities {
#     name = "EnableAggregationPipeline"
#   }

#   capabilities {
#     name = "mongoEnableDocLevelTTL"
#   }

#   # capabilities {
#   #   name = "MongoDBv3.4"
#   # }

#   capabilities {
#     name = "AllowSelfServeUpgradeToMongo36"
#   }

#   capabilities {
#     name = "EnableMongo"
#   }

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }

#   geo_location {
#     location          = var.primary_region
#     failover_priority = 1
#   }

#   geo_location {
#     location          = var.secondary_region
#     failover_priority = 0
#   }
  
#   # Network configuration for access control
#   is_virtual_network_filter_enabled = true
# }

# ## Creating MongoDB database
# resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
#   name                = "${var.prefix}mongo_db${random_integer.ri.result}"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.db.name
#   throughput          = 400
# }

# # Create a private endpoint for the Cosmos DB account
# resource "azurerm_private_endpoint" "cosmos_pe" {
#   name                = "${var.prefix}-cosmos-pe-${random_integer.ri.result}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.cosmos_subnet.id

#   private_service_connection {
#     name                           = "${var.prefix}-cosmos-psc-${random_integer.ri.result}"
#     private_connection_resource_id = azurerm_cosmosdb_account.db.id
#     is_manual_connection           = false
#     subresource_names              = ["MongoDB"]
#   }
  
#   # Optional: Configure DNS zone group
#   private_dns_zone_group {
#     name                 = "cosmos-dns-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_dns.id]
#   }
# }

# # Create a private DNS zone for Cosmos DB
# resource "azurerm_private_dns_zone" "cosmos_dns" {
#   name                = "privatelink.mongo.cosmos.azure.com"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# # Link the private DNS zone to the virtual network
# resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_dns_link" {
#   name                  = "${var.prefix}-cosmos-dns-link-${random_integer.ri.result}"
#   resource_group_name   = data.azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.cosmos_dns.name
#   virtual_network_id    = azurerm_virtual_network.vnet.id  # Reference the VNet from vnet.tf
#   registration_enabled  = true
# }