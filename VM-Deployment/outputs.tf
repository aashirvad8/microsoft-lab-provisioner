output "vm_public_ip" {
  description = "Public IP of the created Windows VM"
  value       = azurerm_public_ip.lab_pip.ip_address
}

output "vm_name" {
  value = azurerm_windows_virtual_machine.lab_vm.name
}
