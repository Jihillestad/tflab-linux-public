# Change Log

## Version 2.3.1 - Minor release

### Refactoring

- Created a separate module for HUb services: ./modules/hubserv
- Moved Bastion, Application Gateway, and NAT Gateway to the new hub services module.

### Documentation

- Updated README files to reflect the new module structure.

## Version 2.2.1 - Patch release

### Bug Fixes

- Fixed network watccher conflict. Now using Azure builtin Network Watcher.

### Refactoring

- Fixed some typos and replaced some variables in ./modules/net/README.md

## Version 2.2.0 - Minor release

### Refactoring

- Moved vnet and subnet definitions to root module for better network module reusability.

### Documentation

- Updated ./modules/net/README.md to reflect changes in module structure.

## Version 2.1.1 - Patch release

### Bug Fixes

- Fixed missing outputs in ./modules/monitoring/outputs.tf
- removed monitoring vars from net module.

### Documentation

- Updated README and CHANGELOG files with recent changes.

## Version 2.1.0 - Minor release

### Refactoring

- Monitoring resources created in a separate module: ./modules/monitoring

### Documentation

- Added monitoring module usage example to ./modules/monitoring/README.md

## Version 2.0.4 - Patch release

### Refactoring

- Created NSG rules as a azurerm_network_security_rule resource instead of inline rules.
- Made NAT and NSG toggles optional via variables.

### Documentation

- Added nsg_id output to ./modules/net/outputs.tf

## Version 2.0.3 - Patch release

### Refactoring

- Improved ./modulules/net/outputs.tf for dynamic subnet outputs.
- Added outputs in ./modules/net/outputs.tf for:
  - Application Gateway
  - NAT Gateway
  - Public IPs for Application Gateway and NAT Gateway

### Documentation

- Updated ./modules/net/README.md with new outputs.

## Version 2.0.2 - Patch release

### Documentation

- Fixed outputs section in ./modules/net/README.md

## Version 2.0.1 - Major release

### Features

#### Networking

- Added Application Gateway with basic HTTP settings, listener, and routing rule.
- Added NAT Gateway associated with Default Subnet for egress traffic.

### Refactoring

- Refactored subnets to DRY and dynamic approach using maps and loops.

### Documentation

- Added more comments for better readability and understanding.

## Version 1.0.1 - Patch release

### Bug Fixes

- Changed hardcoded values to variables in compute and net modules.
- Added validation to important variables.

## Version 1.0.0 - Major release

### Features

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
