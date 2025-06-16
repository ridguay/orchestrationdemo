output "storage_id" {
  description = "The Id of the Storage Account instance"
  value       = azurerm_storage_account.storage.id
}

output "primary_dfs_endpoint" {
  description = "The primary endpoint of the Distributed File System"
  value       = azurerm_storage_account.storage.primary_dfs_endpoint
}

output "name" {
  description = "The name of the Storage Account instance"
  value       = azurerm_storage_account.storage.name
}
