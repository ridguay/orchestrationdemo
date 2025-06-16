# Needed for subnet
data "azurerm_subscription" "subscription" {}

data "azurerm_virtual_network" "virtual_network" {
  resource_group_name = var.subnet__virtual_network_data.resource_group_name
  name                = var.subnet__virtual_network_data.name
}

# We need the object id of the managed identity created by Databricks to be able to give it access to other resources
data "azurerm_user_assigned_identity" "managed_identity" {
  name                = "dbmanagedidentity"
  resource_group_name = azurerm_databricks_workspace.workspace.managed_resource_group_name
}
