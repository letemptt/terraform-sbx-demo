
# Generate random value for unique resource naming
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
# Deploy Azure AI Services resource
resource "azurerm_ai_services" "azais" {
  name                  = "${var.prefix}azais"                     # AI Services resource name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  sku_name            = "S0"                                    # Pricing SKU tier
}

# Create Azure AI Foundry service
resource "azurerm_ai_foundry" "ai-fndry" {
  name                = "${var.prefix}-aifndry-${random_integer.ri.result}"                       # AI Foundry service name
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  application_insights_id       = azurerm_application_insights.appi.id
  key_vault_id                  = azurerm_key_vault.kv.id
  storage_account_id            = azurerm_storage_account.st.id

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}

# Create an AI Foundry Project within the AI Foundry service
resource "azurerm_ai_foundry_project" "azaiproj" {
  name               = "${var.prefix}-azaiproj-${random_integer.ri.result}"                          # Project name
  location           = data.azurerm_resource_group.rg.location # Location from the AI Foundry service
  ai_services_hub_id = data.azurerm_ai_foundry.ai-fndry.id       # Associated AI Foundry service

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}