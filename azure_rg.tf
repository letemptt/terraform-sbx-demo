#
# Resource group
#

# The resource group must be created manually so that the subscription owner
# can grant the terraformer service principal access to the resource group.
# Moreover, we don't want to destroy the resource group when we destroy the
# terraform deployment, so we don't create it here.

#resource "azurerm_resource_group" "rg" {
#  location = var.resource_group_region
#  name     = var.resource_group_name
#}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}
