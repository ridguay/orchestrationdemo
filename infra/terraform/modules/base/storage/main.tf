resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = "West Europe" # or use var.location if defined
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true  # Required for ADLS Gen2

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Allow" # Or "Deny" + allow Databricks subnet
  }

  tags = var.tags
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id   = azurerm_storage_account.storage.id
  container_access_type  = "private"
}