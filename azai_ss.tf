resource "azurerm_search_service" "azss"  {
  name                          = "${var.prefix}azss"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  # Removed invalid attribute key_vault_id
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count
}