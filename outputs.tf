# output "ubuntu_vm1_public_ip" {
#   description = "The public IP address of the Ubuntu virtual machine"
#   value       = module.vm.inet_access_public_ip
# }

output "bastion_host_name" {
  description = "The details of the Bastion Host"
  value       = module.network.bastion_host_name
}
