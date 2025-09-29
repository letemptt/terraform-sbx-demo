#
# Azure Machine Learning prerequisites
#


# Required resources for Azure Machine Learning components
# https://github.com/Azure/terraform/blob/master/quickstart/101-machine-learning/workspace.tf

resource "azurerm_application_insights" "appi" {
  name                = "${var.prefix}appi"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_key_vault" "kv" {
  name                     = "${var.prefix}kv"
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
}

resource "azurerm_storage_account" "st" {
  name                            = "${var.prefix}st"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_container_registry" "cr" {
  name                = "${var.prefix}cr"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  admin_enabled       = true
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Azure AI Service
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account

#resource "azurerm_cognitive_account" "aais" {
#  name                = "${var.prefix}aais"
#  location            = data.azurerm_resource_group.rg.location
#  resource_group_name = data.azurerm_resource_group.rg.name
#  sku_name            = "S0"
#  kind                = "OpenAI"
#}
