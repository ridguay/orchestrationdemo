resource "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace__name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.workspace__tags
  sku                 = "premium"

  managed_resource_group_name = var.workspace__managed_resource_group_name

  custom_parameters {
    no_public_ip = var.workspace__secure_cluster_connectivity

    virtual_network_id                                   = data.azurerm_virtual_network.virtual_network.id
    public_subnet_network_security_group_association_id  = azurerm_subnet.public_subnet.id
    public_subnet_name                                   = azurerm_subnet.public_subnet.name
    private_subnet_network_security_group_association_id = azurerm_subnet.private_subnet.id
    private_subnet_name                                  = azurerm_subnet.private_subnet.name
  }

  depends_on = [data.azurerm_virtual_network.virtual_network]
}
