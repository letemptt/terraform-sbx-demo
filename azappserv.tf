# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.prefix}-webapp-asp-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "${var.prefix}-webapp-${random_integer.ri.result}"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  depends_on            = [azurerm_service_plan.appserviceplan]
  https_only            = true
  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "16-lts"
    }
    linux_fx_version = var.linuxFxVersion # Use the variable defined in variables.tf
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false
}
