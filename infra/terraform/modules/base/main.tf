

### Services Subnet ###
module "services_subnet" {
  source = "./services_subnet"

  subnet_name           = var.services_subnet_vars.subnet_name
  subnet_address_prefix = var.services_subnet_vars.subnet_address_prefix
  virtual_network_data  = var.services_subnet_vars.virtual_network_data
}

### Databricks ###
module "databricks" {
  source = "./databricks"

  resource_group_name = var.resource_group_vars.name

  access_connector__name = var.databricks_vars.access_connector_name
  access_connector__tags = var.databricks_vars.access_connector_tags

  subnet__name                          = var.databricks_vars.subnet_name
  subnet__tags                          = var.databricks_vars.subnet_tags
  subnet__private_subnet_address_prefix = var.databricks_vars.subnet_private_subnet_address_prefix
  subnet__public_subnet_address_prefix  = var.databricks_vars.subnet_public_subnet_address_prefix
  subnet__virtual_network_data = {
    resource_group_name = var.databricks_vars.subnet_virtual_network_data.resource_group_name
    name                = var.databricks_vars.subnet_virtual_network_data.name
  }

  workspace__managed_resource_group_name = var.databricks_vars.workspace_managed_resource_group_name
  workspace__name                        = var.databricks_vars.workspace_name
  workspace__tags                        = var.databricks_vars.workspace_tags
  workspace__secure_cluster_connectivity = var.databricks_vars.workspace_secure_cluster_connectivity
  workspace__private_endpoint_subnet_id  = module.services_subnet.subnet_id
  workspace__private_endpoint_ip         = var.databricks_vars.workspace_private_endpoint_ip

  depends_on = [module.services_subnet]
}

### Storage ###
module "storage" {
  source = "./storage"

  resource_group_name      = var.resource_group_vars.name
  storage_account_location = var.location

  storage_account_name             = var.storage_vars.name
  storage_account_account_tier     = var.storage_vars.account_tier
  storage_account_replication_type = var.storage_vars.replication_type
  delete_policy                    = var.storage_vars.delete_policy
  customer_managed_key             = var.storage_vars.customer_managed_key
  storage_management_policy        = var.storage_vars.storage_management_policy

  tags                       = var.storage_vars.tags
  storage_account_extra_tags = var.storage_vars.storage_account_extra_tags

  network_control_allowed_subnet_ids = concat(var.storage_vars.network_control_allowed_subnet_ids, [module.databricks.private_subnet_id, module.databricks.public_subnet_id])
  network_control_allowed_ip_rules   = var.storage_vars.network_control_allowed_ip_rules
  configure_default_network_rules    = var.storage_vars.configure_default_network_rules
  private_link_access_tenant_id      = var.tenant_id
  private_link_access_resource_id    = module.databricks.databricks_access_connector_resource_id
  add_private_link_access            = var.storage_vars.add_private_link_access
  network_rules_bypasses             = var.storage_vars.network_rules_bypasses
  private_endpoint_subnet_id         = module.services_subnet.subnet_id
  dfs_private_endpoint_ip            = var.storage_vars.dfs_private_endpoint_ip
  blob_private_endpoint_ip           = var.storage_vars.blob_private_endpoint_ip
  container_names                    = var.storage_vars.container_names
  shared_access_key_enabled          = true
  default_to_oauth_authentication    = false
  depends_on = [module.databricks, module.services_subnet]
}

