### Generic Vars ###

variable "tenant_id" {
  description = "Id of the tenant to deploy the platform to."
  type        = string
}

variable "location" {
  description = "Region to deploy the platform to."
  type        = string
  default     = "West Europe"
}

### Module Specific Vars ###
variable "resource_group_vars" {
  type = object({
    name = string
    tags = optional(map(string), {})
  })
}

variable "services_subnet_vars" {
  type = object({
    subnet_name           = string
    subnet_address_prefix = string
    virtual_network_data = object({
      resource_group_name = string
      name                = string
    })
  })
}

variable "databricks_vars" {
  type = object({
    access_connector_name = string
    access_connector_tags = optional(map(string), {})

    subnet_name                          = string
    subnet_tags                          = optional(map(string), {})
    subnet_private_subnet_address_prefix = string
    subnet_public_subnet_address_prefix  = string
    subnet_virtual_network_data = object({
      resource_group_name = string
      name                = string
    })

    workspace_managed_resource_group_name = string
    workspace_name                        = string
    workspace_tags                        = optional(map(string), {})
    workspace_secure_cluster_connectivity = optional(bool, true) # Read more at https://docs.microsoft.com/en-us/azure/databricks/security/secure-cluster-connectivity"
    workspace_private_endpoint_ip         = string
    workspace_vnet_resource_group_name    = string
  })
}

variable "key_vault_sources_vars" {
  type = object({
    name                                   = string
    sku_name                               = optional(string, "standard")
    tags                                   = optional(map(string), {})
    soft_delete_retention_days             = optional(number, 90)
    enable_purge_protection                = optional(bool, true)
    enable_rbac_authorization              = optional(bool, false)
    enable_disk_encryption                 = optional(bool, false)
    network_control_allowed_subnet_ids     = optional(list(string), null)
    network_control_allowed_ip_rules       = optional(list(string), null)
    network_control_allowed_azure_services = optional(bool, false)
    create_private_endpoint                = optional(bool, true)
    private_endpoint_ip                    = string
  })

  default = null
}

variable "storage_vars" {
  type = object({
    name                               = string
    tags                               = optional(map(string), {})
    storage_account_extra_tags         = optional(map(string), {})
    account_tier                       = optional(string, "Standard")
    replication_type                   = optional(string, "ZRS")
    network_control_allowed_subnet_ids = optional(list(string), null)
    network_control_allowed_ip_rules   = optional(list(string), null)
    configure_default_network_rules    = optional(bool, true)
    private_link_access_resource_id    = optional(string, null)
    add_private_link_access            = optional(bool, false)
    network_rules_bypasses             = optional(list(string), ["Logging", "Metrics", "AzureServices"])
    delete_policy = optional(object({
      blob_delete_retention      = string
      container_delete_retention = string
    }), null)
    customer_managed_key = optional(object({
      datalake_key_vault_id   = string
      datalake_key_vault_name = string
      key_name                = string
    }), null)
    dfs_private_endpoint_ip   = string
    blob_private_endpoint_ip  = string
    storage_management_policy = optional(
      object({
        move_to_cool_after_days = number
      }),
      {
        move_to_cool_after_days = 304
      }
    )
    container_names                 = list(string)
    shared_access_key_enabled       = optional(bool, false)
    default_to_oauth_authentication = optional(bool, true)
  })
}

