data "azurerm_subscription" "subscription" {
}

data "azurerm_virtual_network" "virtual_network" {
  resource_group_name = var.virtual_network_data.resource_group_name
  name                = var.virtual_network_data.name
}
