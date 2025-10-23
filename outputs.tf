output "vm_public_ip" {
  description = "Public IP address of the Windows VM"
  value       = azurerm_public_ip.lab_pip.ip_address
}

output "resource_group" {
  description = "Resource Group Name"
  value       = local.rg_name
}

output "resource_group_location" {
  description = "Resource Group Location"
  value       = local.rg_location
}
