include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${get_env("TERRAGRUNT_TERRAFORM_DIR")}/modules/base///"
}

generate "provider_databricks" {
  path      = "provider-databricks_workspace.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "databricks" {
  alias    = "default"
  azure_client_id = "${include.root.locals.env_variables.client_id}"
  azure_client_secret = var.azure_client_secret
}
EOF
}

generate "provider_azapi" {
  path      = "provider-azapi.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azapi" {
  client_id = "${include.root.locals.env_variables.client_id}"
  subscription_id = "${include.root.locals.env_variables.subscription_id}"
  tenant_id = "${include.root.locals.env_variables.tenant_id}"
  client_secret = var.azure_client_secret
}
EOF
}

locals {
  containers_names = [
    "raw"
  ]
}

inputs = {
  # General inputs
  tenant_id = "${include.root.locals.env_variables.tenant_id}"

  # Resource specific inputs
  resource_group_vars = {
    name = "${include.root.locals.resource_group_name}"
    tags = try(include.root.locals.env_variables.tags, {})
  }

  services_subnet_vars = {
    subnet_name           = "snet-${include.root.locals.environment_label_short}-services"
    subnet_address_prefix = "${include.root.locals.product_variables.ip_addresses.services_subnet}"
    virtual_network_data  = include.root.locals.env_variables.virtual_network_data
  }

  databricks_vars = {
    # Access connector inputs
    access_connector_name = "dac-${include.root.locals.environment_label}"
    access_connector_tags = include.root.locals.env_variables.tags

    # Subnet inputs
    subnet_name                          = "snet-${include.root.locals.environment_label_short}-databricks"
    subnet_tags                          = include.root.locals.env_variables.tags
    subnet_public_subnet_address_prefix  = "${include.root.locals.product_variables.ip_addresses.databricks_public_subnet}"
    subnet_private_subnet_address_prefix = "${include.root.locals.product_variables.ip_addresses.databricks_private_subnet}"
    subnet_virtual_network_data          = include.root.locals.env_variables.virtual_network_data

    # Workspace inputs
    workspace_name                        = "dbw-${include.root.locals.environment_label}"
    workspace_tags                        = include.root.locals.env_variables.tags
    workspace_managed_resource_group_name = "dbw-${include.root.locals.environment_label}-mrg"
    workspace_private_endpoint_ip         = "${include.root.locals.product_variables.ip_addresses.databricks_private_endpoint}"
    workspace_vnet_resource_group_name    = "${include.root.locals.resource_group_name}"
  }


  storage_vars = {
    name = replace("st${include.root.locals.environment_label}", "-", "")
    tags = include.root.locals.env_variables.tags

    delete_policy = {
      blob_delete_retention      = 90
      container_delete_retention = 90
    }

    network_control_allowed_subnet_ids = []
    network_control_allowed_ip_rules = []

    dfs_private_endpoint_ip   = "${include.root.locals.product_variables.ip_addresses.storage_dfs_private_endpoint}"
    blob_private_endpoint_ip  = "${include.root.locals.product_variables.ip_addresses.storage_blob_private_endpoint}"


    add_private_link_access = true

    configure_default_network_rules = try(include.root.locals.infrastructure_configuration.configure_default_network_rules_storage, true)
    container_names                = local.containers_names
    
  }

}

