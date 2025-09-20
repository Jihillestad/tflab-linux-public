# Description: This Terraform configuration creates a public IP address and a network interface in Azure.
# The public IP address is statically allocated and uses the Standard SKU. The network interface is
# associated with the public IP address and is configured to use a specified subnet.


# Random string for unique naming

resource "random_string" "main" {
  length  = 3
  special = false
  numeric = true
}


# Storage Account for Boot Diagnostics

resource "azurerm_storage_account" "boot_diagnostics_sa" {
  name                = "${var.prefix}${var.project_name}btsa${random_string.main.result}"
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier               = var.sa_account_tier
  account_kind               = var.sa_account_kind
  account_replication_type   = var.sa_account_replication_type
  https_traffic_only_enabled = true
}


# Public IP for internet access

resource "azurerm_public_ip" "inet_access" {
  name                = "${var.prefix}-${var.project_name}-inet-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


# Network Interface for Compute resources

resource "azurerm_network_interface" "inet_nic" {
  name                = "${var.prefix}-${var.project_name}-vm-nic-${random_string.main.result}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "connectivity"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.inet_access.id
  }

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
