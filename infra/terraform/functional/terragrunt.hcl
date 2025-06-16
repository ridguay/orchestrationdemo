include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${get_env("TERRAGRUNT_TERRAFORM_DIR")}/modules/functional///"
}

dependency "base" {
  config_path = "${get_env("TERRAGRUNT_TERRAFORM_DIR")}/base"
  mock_outputs = {
    resource_group__name                = "rg-demov001-func"
    resource_group__id                  = "00000000-0000-0000-0000-000000000000"
    databricks__workspace_url           = "adb-demov001-func.azuredatabricks.net"
    databricks__workspace_id            = "00000000-0000-0000-0000-000000000000"
    databricks__access_connector_principal_id = "00000000-0000-0000-0000-000000000001"
    storage__storage_account_name       = "stdemov001func"
    storage__storage_account_id         = "00000000-0000-0000-0000-000000000002"
  }
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

generate "provider_databricks" {
  path      = "provider-databricks.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "databricks" {
  host = "${dependency.base.outputs.databricks__workspace_url}"

  azure_client_id = "${include.root.locals.env_variables.client_id}"
  azure_tenant_id = "${include.root.locals.env_variables.tenant_id}"
  azure_client_secret = var.azure_client_secret
}
EOF
}

locals {

  unity_catalog_group_name = "demo-${include.root.locals.env_variables.env_name}-${include.root.locals.product_variables.abbreviation}-uc"

}

inputs = {
  resource_group_name              = include.root.locals.resource_group_name
  tags                             = include.root.locals.env_variables.tags
  
  databricks_functional_vars = {

    # Databricks Asset Bundles
    workspace_url = "https://${dependency.base.outputs.databricks__workspace_url}"
    env_domain    = "${include.root.locals.env_variables.env_name}-${include.root.locals.product_variables.abbreviation}"

    # Variables for Primary Cluster(s)
    cluster_name          = "cluster_main"
    cluster_config        = include.root.locals.infrastructure_configuration.databricks_main_clusters

    # UC enabled
    cluster_uc_enabled = true
    cluster_unity_catalog_volume_storage_account_name   = replace("st${include.root.locals.environment_label}", "-", "")
    cluster_unity_catalog_volume_storage_container_name = "uc-container-eneco"
    cluster_unity_catalog_volume_name                   = "uc-volume-eneco"

    # Variables for unity catalog schema
    env    = include.root.locals.env_variables.env_name
    domain = include.root.locals.product_variables.abbreviation
    unity_catalog_group_name = local.unity_catalog_group_name
    unity_catalog_sp_name    = include.root.locals.env_variables.client_id

  }

  storage_role_assignments_vars = {
    resource_ids         = [dependency.base.outputs.storage__storage_account_id]
    user_principal_roles = {}
    principal_id_roles = {"${dependency.base.outputs.databricks__access_connector_principal_id}" = ["Storage Account Contributor", "Storage Blob Data Contributor", "Storage Queue Data Contributor", "EventGrid EventSubscription Contributor"] }
    
  }


}

retryable_errors = [
  "(?s).*each.value*",
  "(?s).*unexpected state Pending.*"
]
