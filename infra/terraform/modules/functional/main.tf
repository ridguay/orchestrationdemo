### Databricks ###
module "databricks" {
  source = "./databricks"

  providers = {
    azurerm      = azurerm
    databricks   = databricks
  }

  count = var.databricks_functional_vars == null ? 0 : 1
  # Notebook Mounting Secrets
  notebook_mounting_secret_scope = var.databricks_functional_vars.notebook_mounting_secret_scope
  notebook_mounting_secrets      = var.databricks_functional_vars.notebook_mounting_secrets

  # Variables for Primary Cluster(s)
  cluster__name                       = var.databricks_functional_vars.cluster_name
  cluster__spark_version_id            = var.databricks_functional_vars.cluster_config.spark_version_id
  cluster__node_type_id                = var.databricks_functional_vars.cluster_config.node_type_id
  cluster__autoterminate_after_minutes = var.databricks_functional_vars.cluster_config.autoterminate_after_minutes
  cluster__tags                        = var.databricks_functional_vars.cluster_config.tags
  cluster__minimum_workers             = var.databricks_functional_vars.cluster_config.minimum_workers
  cluster__maximum_workers             = var.databricks_functional_vars.cluster_config.maximum_workers
  cluster__extra_spark_configuration   = var.databricks_functional_vars.cluster_config.extra_spark_configuration
  cluster__runtime_engine              = var.databricks_functional_vars.cluster_config.runtime_engine
  cluster__unity_catalog_volume_name                   = var.databricks_functional_vars.cluster_unity_catalog_volume_name
  cluster__unity_catalog_volume_storage_account_name   = var.databricks_functional_vars.cluster_unity_catalog_volume_storage_account_name
  cluster__unity_catalog_volume_storage_container_name = var.databricks_functional_vars.cluster_unity_catalog_volume_storage_container_name


  # Variables for DAB secrets
  workspace_url = var.databricks_functional_vars.workspace_url
  env_domain    = var.databricks_functional_vars.env_domain

  # Variables for unity catalog
  unity_catalog_group_name = var.databricks_functional_vars.unity_catalog_group_name
  unity_catalog_sp_name    = var.databricks_functional_vars.unity_catalog_sp_name

  depends_on = [
    module.storage_role_assignments
  ]
}



