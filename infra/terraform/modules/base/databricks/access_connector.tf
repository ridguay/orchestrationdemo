resource "azurerm_databricks_access_connector" "dac" {
  name                = var.access_connector__name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  tags = var.access_connector__tags
}
