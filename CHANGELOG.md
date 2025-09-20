# Change Log

## Version 1.0.0 - Major release

## Features

#### Compute

- Storage Account for Boot Diagnostics
- Azure Linux Virtual Machine
- Ubuntu 22.04 LTS
  - Size: Standard_DS1_v2
  - Network Interface for Compute VM
    - Public IP for Compute VM
    - IP from Default Subnet
  - SSH Key Authentication

## Version 0.1.1-3

### Features

#### Networking

- Vnet with subnets:
  - Default subnet
  - Bastion subnet
  - Public IP for Bastion
- Network Security Groups (NSGs) with basic rules:
  - Allow SSH (port 22) inbound (Keeping it simple for lab usage)

#### Monitoring

- Log Analytics Workspace
- Network Watcher
  - Virtual Network flow logs enabled
- Storage Account for flow logs

#### Compute

This release is for showing how to set up a basic Linux VM in Azure. The
Terraform code creates the necessary Azure boilerplate needed for a VM, and
some basic LZ stuff.

- Public IP for Compute VM
- Network Interface for Compute VM
  - IP from Default Subnet
  - Public IP for Compute CM
