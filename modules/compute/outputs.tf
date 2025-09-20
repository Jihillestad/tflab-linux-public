output "inet_access_public_ip" {
  description = "The public IP address for internet access"
  value       = azurerm_public_ip.inet_access.ip_address
}

output "inet_nic_id" {
  description = "The ID of the network interface for internet access"
  value       = azurerm_network_interface.inet_nic.id
}

output "ubuntu_vm1_id" {
  description = "The ID of the Ubuntu virtual machine"
  value       = azurerm_linux_virtual_machine.ubuntu_vm1.id
}
