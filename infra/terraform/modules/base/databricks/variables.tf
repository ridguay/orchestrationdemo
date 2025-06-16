variable "resource_group_name" {
  description = "The Resource Group name of the Databricks components"
  type        = string
}
variable "location" {
  description = "Location of the Databricks components"
  type        = string
  default     = "West Europe"
}

variable "access_connector__name" {
  description = "Databricks Access Connector name"
  type        = string
}

variable "access_connector__tags" {
  description = "Tags to assign to Databricks Access Connector"
  type        = map(string)
  default     = {}
}

variable "subnet__name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet__tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "subnet__private_subnet_address_prefix" {
  description = "Subnet private address prefix"
  type        = string
}

variable "subnet__public_subnet_address_prefix" {
  description = "Subnet public address prefix"
  type        = string
}

variable "subnet__virtual_network_data" {
  description = "Information of the virtual network to retrieve its data object"
  type = object({
    resource_group_name = string
    name                = string
  })
}

variable "workspace__name" {
  description = "Databricks Workspace name"
  type        = string
}

variable "workspace__tags" {
  description = "Tags to assign to Databricks Workspace instance"
  type        = map(string)
  default     = {}
}

variable "workspace__managed_resource_group_name" {
  type        = string
  description = "Databricks Workspace managed resource group name"

}

variable "workspace__secure_cluster_connectivity" {
  description = "Indicates whether the secure cluster connectivity is enabled for the Databricks Workspace instance"
  type        = bool
  default     = true
}

variable "workspace__private_endpoint_subnet_id" {
  description = "The subnet id to deploy the private endpoint into"
  type        = string
}

variable "workspace__private_endpoint_ip" {
  description = "Ip of the private endpoint."
  type        = string
}
