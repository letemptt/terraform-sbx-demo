#
# Azure Machine Learning Studio
#

# https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-workspace-terraform


# resource "azurerm_eventhub_namespace" "ehnsp" {
#   name                          = "${var.prefix}ehnsp"
#   location                      = data.azurerm_resource_group.rg.location
#   resource_group_name           = data.azurerm_resource_group.rg.name
#   sku = "Standard"
#   capacity = 2
#   public_network_access_enabled = true

#   identity {
#     type = "SystemAssigned"
#   }
#   tags = {
#     environment = "sbx"
#   }
# }
# resource "azurerm_eventhub" "eh" {
#   name                = "${var.prefix}eh"
#   namespace_name      = azurerm_eventhub_namespace.ehnsp.name
#   resource_group_name = azurerm_eventhub_namespace.ehnsp.resource_group_name
#   partition_count     = 2
#   message_retention   = 1
# }