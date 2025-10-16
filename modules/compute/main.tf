# Description: This Terraform configuration creates a network interface in Azure.
# The network interface is configured with a private IP only (no public IP)
# and is associated with Application Gateway backend pool for secure ingress.


# Random string for unique naming
resource "random_string" "main" {
  length  = 6
  special = false
  numeric = true
  lower   = true
  upper   = false
}


# Storage Account for Boot Diagnostics
resource "azurerm_storage_account" "boot_diagnostics_sa" {
  name                = substr(lower("${var.prefix}${var.project_name}btsa${random_string.main.result}"), 0, 24) # Storage account names must be globally unique and between 3-24 characters. Overflow handled by substr function.
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier               = var.sa_account_tier
  account_kind               = var.sa_account_kind
  account_replication_type   = var.sa_account_replication_type
  https_traffic_only_enabled = true
}


# Network Interface for Compute resources (Private IP only)
resource "azurerm_network_interface" "inet_nic" {
  name                = "${var.prefix}-${var.project_name}-vm-nic-${random_string.main.result}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "connectivity"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}


# Associate Network Interface with Application Gateway Backend Pool
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgw_backend" {
  network_interface_id    = azurerm_network_interface.inet_nic.id
  ip_configuration_name   = "connectivity"
  backend_address_pool_id = var.appgw_backend_pool_id
}


# Data Disk
resource "azurerm_managed_disk" "webapp_data_disk" {
  name                 = "${var.prefix}-${var.project_name}-data-disk-${random_string.main.result}-${var.environment}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4

  tags = var.tags
}


# Linux VM
resource "azurerm_linux_virtual_machine" "ubuntu_vm1" {
  name                = "${var.prefix}-${var.project_name}-vm-${random_string.main.result}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.inet_nic.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${var.prefix}-${var.project_name}-vm-osdisk-${random_string.main.result}-${var.environment}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.boot_diagnostics_sa.primary_blob_endpoint
  }

  tags = var.tags
}


# Attach Data Disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "example_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.webapp_data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.ubuntu_vm1.id
  lun                = 0
  caching            = "None"
}
