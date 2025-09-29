
# ##NOTE: the Name used for Redis needs to be globally unique
# resource "azurerm_redis_cache" "rc" {
#   name                 = "${var.prefix}rc"
#   location             = data.azurerm_resource_group.rg.location
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   capacity             = 2
#   family               = "C"
#   sku_name             = "Standard"
#   non_ssl_port_enabled = false
#   minimum_tls_version  = "1.2"

#   redis_configuration {
#     aof_backup_enabled              = false
#   }
# }