output "inet_nic_id" {
  description = "The ID of the network interface for internet access"
  value       = azurerm_network_interface.inet_nic.id
}

output "ubuntu_vm1_id" {
  description = "The ID of the Ubuntu virtual machine"
  value       = azurerm_linux_virtual_machine.test_vm1.id
}

output "private_ip_address" {
  description = "The private IP address of the VM"
  value       = azurerm_network_interface.inet_nic.private_ip_address
}
