
output "private_subnet_id" {
  description = "The private subnet id for the Databricks workspace."
  value       = azurerm_subnet.private_subnet.id
}

output "private_subnet_name" {
  description = "The private subnet name for the Databricks workspace."
  value       = azurerm_subnet.private_subnet.name
}

output "public_subnet_id" {
  description = "The public subnet id for the Databricks workspace."
  value       = azurerm_subnet.public_subnet.id
}

output "public_subnet_name" {
  description = "The private subnet id for the Databricks workspace."
  value       = azurerm_subnet.public_subnet.name
}

output "databricks_access_connector_principal_id" {
  description = "The principal id of the managed identity is needed to assign role."
  value       = azurerm_databricks_access_connector.dac.identity[0].principal_id
}

output "databricks_access_connector_resource_id" {
  description = "The resource id of databricks access connector."
  value       = azurerm_databricks_access_connector.dac.id
}

output "databricks_workspace_id" {
  description = "The ID of the databricks workspace instance."
  value       = azurerm_databricks_workspace.workspace.id
}

output "databricks_workspace_url" {
  description = "The URL of the databricks workspace instance."
  value       = azurerm_databricks_workspace.workspace.workspace_url
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity created by Databricks for the workspace"
  value       = data.azurerm_user_assigned_identity.managed_identity.principal_id
}