resource "azurerm_network_security_group" "firewall" {
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  name                = "nsg-${var.subnet_name}"
  location            = var.location
  tags                = var.tags


}

resource "azurerm_network_security_rule" "allow_ir_remote_access" {
  resource_group_name         = data.azurerm_virtual_network.virtual_network.resource_group_name
  network_security_group_name = azurerm_network_security_group.firewall.name
  name                        = "AllowIntegrationRuntimeRemoteAccess"
  priority                    = 2000

  access                     = "Allow"
  direction                  = "Inbound"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "*"
  destination_port_ranges    = ["443", "8060"]
  destination_address_prefix = var.subnet_address_prefix

  depends_on = [
    azurerm_network_security_group.firewall
  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.subnet_address_prefix]
  service_endpoints = [
    "Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"
  ]
  private_endpoint_network_policies = "Enabled"

  depends_on = [
    azurerm_network_security_rule.allow_ir_remote_access
  ]
}

resource "azapi_update_resource" "firewall_association" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  resource_id = azurerm_subnet.subnet.id

  body = jsonencode({
    properties = {
      networkSecurityGroup = {
        id = azurerm_network_security_group.firewall.id
      }

    }
  })

  depends_on = [
    azurerm_subnet.subnet,
    azurerm_network_security_group.firewall
  ]
}
