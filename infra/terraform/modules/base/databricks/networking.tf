resource "azurerm_network_security_group" "firewall" {
  resource_group_name = var.subnet__virtual_network_data.resource_group_name
  name                = "nsg-${var.subnet__name}"
  location            = var.location

  lifecycle {
    ignore_changes = [
      security_rule # Security rules are managed using `azurerm_network_security_rule` resources
    ]
  }
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.subnet__name}-private"
  resource_group_name  = var.subnet__virtual_network_data.resource_group_name
  virtual_network_name = var.subnet__virtual_network_data.name
  address_prefixes     = [var.subnet__private_subnet_address_prefix]
  service_endpoints = [
    "Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"
  ]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }

  depends_on = [
    azurerm_network_security_group.firewall # Ensure proper destroy order
  ]
}

# Link the subnet to the network security group
resource "azapi_update_resource" "private_firewall_association" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  resource_id = azurerm_subnet.private_subnet.id

  body = jsonencode({
    properties = {
      networkSecurityGroup = {
        id = azurerm_network_security_group.firewall.id
      }

    }
  })

  depends_on = [
    azurerm_subnet.private_subnet,
    azurerm_network_security_group.firewall
  ]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.subnet__name}-public"
  resource_group_name  = var.subnet__virtual_network_data.resource_group_name
  virtual_network_name = var.subnet__virtual_network_data.name
  address_prefixes     = [var.subnet__public_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"
  ]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }

  depends_on = [
    azurerm_subnet.private_subnet,
    azapi_update_resource.private_firewall_association,
    azurerm_network_security_group.firewall # Ensure proper destroy order
  ]
}

# Link the subnet to the network security group
resource "azapi_update_resource" "public_firewall_association" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  resource_id = azurerm_subnet.public_subnet.id

  body = jsonencode({
    properties = {
      networkSecurityGroup = {
        id = azurerm_network_security_group.firewall.id
      }

    }
  })

  depends_on = [
    azurerm_subnet.public_subnet,
    azurerm_network_security_group.firewall,
  ]
}
