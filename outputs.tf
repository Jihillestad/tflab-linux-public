# output "ubuntu_vm1_public_ip" {
#   description = "The public IP address of the Ubuntu virtual machine"
#   value       = module.vm.inet_access_public_ip
# }

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.hub_network.vnet_id
}
