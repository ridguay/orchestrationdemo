variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "location" {
  description = "Location of the resource"
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "subnet_address_prefix" {
  description = "Subnet prefix"
  type        = string
}

variable "virtual_network_data" {
  description = "Information of the virtual network to retrieve its data object"
  type = object({
    resource_group_name = string
    name                = string
  })
}