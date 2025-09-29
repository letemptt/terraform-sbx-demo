
# resource "random_integer" "ri" {
#   min = 10000
#   max = 99999
# }

resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.prefix}db${random_integer.ri.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  automatic_failover_enabled = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.primary_region
    failover_priority = 1
  }

  geo_location {
    location          = var.secondary_region
    failover_priority = 0
  }
  mongo_server_version = "4.0"
}

## Creating MongoDB database
resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = "${var.prefix}mongo_db${random_integer.ri.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}