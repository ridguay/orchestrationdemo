output "services_subnet__id" {
  value = module.services_subnet.subnet_id
}

output "services_subnet__name" {
  value = module.services_subnet.subnet_name
}

output "services_subnet__nsg_id" {
  value = module.services_subnet.network_security_group_id
}

output "services_subnet__nsg_name" {
  value = module.services_subnet.network_security_group_name
}

output "storage__storage_account_id" {
  value = module.storage.storage_id
}

output "storage__storage_account_name" {
  value = module.storage.name
}

output "storage__primary_dfs_endpoint" {
  value = module.storage.primary_dfs_endpoint
}

output "databricks__private_subnet_id" {
  value = module.databricks.private_subnet_id
}

output "databricks__public_subnet_id" {
  value = module.databricks.public_subnet_id
}

output "databricks__workspace_url" {
  value = module.databricks.databricks_workspace_url
}

output "databricks__workspace_id" {
  value = module.databricks.databricks_workspace_id
}

output "databricks__managed_identity_principal_id" {
  value = module.databricks.managed_identity_principal_id
}

output "databricks__access_connector_principal_id" {
  value = module.databricks.databricks_access_connector_principal_id
}

