
## Creating MongoDB account
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_mongo_cluster" "mcdb" {
  name                = "${var.prefix}-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  administrator_username = var.mongoAdminUsername
  administrator_password = var.mongoAdminPassword
  shard_count         = 1
  compute_tier = "M40"
  high_availability_mode = "ZoneRedundantPreferred"
  storage_size_in_gb = 32
  version = "5.0"

}

## MongoDB database with Replication
# resource "azurerm_mongo_cluster" "mcdb" {
#   name                = "${var.prefix}-${random_integer.ri.result}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   administrator_username = var.mongoAdminUsername
#   administrator_password = var.mongoAdminPassword
#   shard_count         = 1
#   compute_tier = "M40"
#   high_availability_mode = "ZoneRedundantPreferred"
#   storage_size_in_gb = 32
#   preview_features = ["GeoReplicas"]
#   version = "5.0"

# }
# resource "azurerm_mongo_cluster" "mcdb_geo_replica" {
#   name                = "${var.prefix}-${random_integer.ri.result}-geo-replica"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = "${var.secondary_region}"
#   source_server_id    = azurerm_mongo_cluster.mcdb.id
#   source_location     = data.azurerm_resource_group.rg.location
#   create_mode         = "GeoReplica"

#   lifecycle {
#     ignore_changes = [administrator_username, high_availability_mode, preview_features, shard_count, storage_size_in_gb, compute_tier, version]
#   }
# }