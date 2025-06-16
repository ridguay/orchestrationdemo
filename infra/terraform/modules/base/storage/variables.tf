variable "resource_group_name" {
  description = "The Resource Group name of the Storage Account instance"
  type        = string
}

variable "storage_account_location" {
  description = "The location of the Storage Account instance"
  type        = string
  default     = "West Europe"

  validation {
    condition     = contains(["West Europe"], var.storage_account_location)
    error_message = "Resource location is not allowed. Valid value is West Europe."
  }
}

variable "tags" {
  description = "Tags to assign to Storage Account instance"
  type        = map(string)
  default     = {}
}

variable "storage_account_extra_tags" {
  description = "Extra tags to assign to a Storage Account instance"
  type        = map(string)
  default     = {}
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"

}

variable "storage_account_account_tier" {
  description = "The used tier for the Storage Account instance\nExample: {Standard,Premium}"
  type        = string
  default     = "Standard"

}

variable "storage_account_replication_type" {
  type        = string
  default     = "ZRS"
  description = "Defines the type of replication to use for the Storage Account instance\nPossible values: {LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS}"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The replication type of the Storage Account instance must be LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  }
}

variable "network_control_allowed_subnet_ids" {
  description = "One or more subnet resource ids which should be able to access this Storage Account instance"
  type        = list(string)
  default     = null
}

variable "network_control_allowed_ip_rules" {
  description = "One or more ip addresses, or CIDR Blocks which should be able to access the Storage Account instance"
  type        = list(string)
  default     = null
}

variable "configure_default_network_rules" {
  description = "Boolean if you want to implement default networking rules"
  type        = bool
  default     = true
}

variable "private_link_access_tenant_id" {
  description = "Tenant id to use for private link access to storage account"
  type        = string
  default     = null
}

variable "private_link_access_resource_id" {
  description = "Resource id of resource to allow private link access to storage account"
  type        = string
  default     = null
}

variable "add_private_link_access" {
  description = "boolean to determine whether to create a storage account or not"
  type        = bool
  default     = false
}

variable "network_rules_bypasses" {
  description = "Special network rules for Azure/logging services accessing ADLS."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]

}

variable "delete_policy" {
  description = "Specifies the number of days that the blob/container should be retained"
  type = object({
    blob_delete_retention      = string, # Specifies the number of days that the blob should be retained, between 1 and 365 days.
    container_delete_retention = string  # Specifies the number of days that the container should be retained, between 1 and 365 days.
  })
  default = null
}

variable "customer_managed_key" {
  description = "Information to create a Customer Managed Key for the Storage Account instance"
  type = object({
    datalake_key_vault_id   = string,
    datalake_key_vault_name = string,
    key_name                = string
  })
  default = null
}

variable "private_endpoint_subnet_id" {
  description = "The resource id of the subnet to deploy the private endpoint into"
  type        = string
}

variable "dfs_private_endpoint_ip" {
  description = "Ip of the dfs private endpoint."
  type        = string
}

variable "blob_private_endpoint_ip" {
  description = "Ip of the blob private endpoint."
  type        = string
}


variable "storage_management_policy" {
  description = "Storage policies for hot, cool and archive data storage"

  type = object({
    move_to_cool_after_days = number
  })

  validation {
    condition     = (var.storage_management_policy.move_to_cool_after_days > 1)
    error_message = "Value of storage_management_policy.move_to_cool_after_days must be greater than 1."
  }

  default = {
    move_to_cool_after_days = 304
  }
}

variable "container_names" {
  description = "Names of the containers to be created within the storage account"
  type        = list(string)
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key"
  type        = bool
  default     = false
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account"
  type        = bool
  default     = true
}
