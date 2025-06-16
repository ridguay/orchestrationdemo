output "subnet_id" {
  description = "Subnet resource id"
  value       = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "Subnet name"
  value       = azurerm_subnet.subnet.name
}

output "network_security_group_id" {
  description = "Subnet Network security group resource id"
  value       = azurerm_network_security_group.firewall.id
}

output "network_security_group_name" {
  description = "Subnet Network security group name"
  value       = azurerm_network_security_group.firewall.name
}
