#
# Azure Machine Learning Studio
#

# https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-workspace-terraform

resource "azurerm_machine_learning_workspace" "tll" {
  name                          = "${var.prefix}tll"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  application_insights_id       = azurerm_application_insights.appi.id
  key_vault_id                  = azurerm_key_vault.kv.id
  storage_account_id            = azurerm_storage_account.st.id
  container_registry_id         = azurerm_container_registry.cr.id
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }
}