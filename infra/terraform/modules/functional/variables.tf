## Generic Vars ##
variable "resource_group_name" {
  type        = string
  description = "The Resource Group name"
}

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The location to deploy all resources to"
  type        = string
  default     = "West Europe"
}

variable "databricks_functional_vars" {
  type = object({
   
    # Databricks Asset Bundles
    workspace_url = optional(string, "")
    env_domain    = optional(string, "")

    # Notebook Mounting Secrets
    notebook_mounting_secret_scope = string
    notebook_mounting_secrets      = map(string)

    # Variables for Primary Cluster(s)
    cluster_name = string
    cluster_config = object({
      legacy_spark_version_id     = optional(string, "12.2.x-scala2.12")
      spark_version_id            = optional(string, "15.4.x-scala2.12")
      runtime_engine              = optional(string, "STANDARD")
      node_type_id                = optional(string, "Standard_D4s_v3")
      autoterminate_after_minutes = optional(number, 15)
      tags                        = optional(map(string), {})
      minimum_workers             = optional(number, 1)
      maximum_workers             = optional(number, 2)
      extra_spark_configuration   = optional(map(string), {})
    })
    cluster_pypi_packages = optional(list(string), [])

    cluster_unity_catalog_volume_name                   = string
    cluster_unity_catalog_volume_storage_account_name   = string
    cluster_unity_catalog_volume_storage_container_name = string

    # Unity catalog volume / schema Entra group name, service principal name
    unity_catalog_group_name = string
    unity_catalog_sp_name    = string

  })
  default = null
}



variable "databricks_role_assignments_vars" {
  type = object({
    resource_ids         = list(string)
    user_principal_roles = optional(map(list(string)), {})
    principal_id_roles   = optional(map(list(string)), {})
  })
  default = null
}


variable "storage_role_assignments_vars" {
  type = object({
    resource_ids         = list(string)
    user_principal_roles = optional(map(list(string)), {})
    principal_id_roles   = optional(map(list(string)), {})
  })
  default = null
}

variable "interface_storage_role_assignments_vars" {
  type = object({
    resource_ids         = list(string)
    user_principal_roles = optional(map(list(string)), {})
    principal_id_roles   = optional(map(list(string)), {})
  })
  default = null
}


