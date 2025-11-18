# tflab-linux

This repository contains a simplified single Resource Group Azure Landing Zone (LZ) setup intended for learning and experimentation purposes. It is not designed for production use.
**The SSH key pair is stored in plain text in Terraform state. Use for lab and learning only, deploy Key Vaults and Secrets outside Terraform in production environments.**

**Architecture:** Hub-and-Spoke pattern with modular Terraform design.

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.5 installed
- Storage Account for Terraform backend (optional, but recommended)
- Azure subscription with appropriate permissions

## 🏗️ Architecture Overview

This project implements a **hub-and-spoke network topology** with the following modules:

```
┌────────────────────────────────────┐
│        Hub VNet (10.0.0.0/16)      │
│  ┌──────────┐  ┌──────────────┐    │
│  │ Bastion  │  │  App Gateway │    │
│  └──────────┘  └──────────────┘    │
│  ┌─────────────────────────────┐   │
│  │  NAT Gateway (shared)       │   │
│  └─────────────────────────────┘   │
└────────────────────────────────────┘
```

### Modules

- **`modules/net/`** - Generic VNet module (reusable for hub and spokes)
- **`modules/hubserv/`** - Hub services (Bastion, NAT Gateway, App Gateway)
- **`modules/monitoring/`** - Observability (Log Analytics, Network Watcher)
- **`modules/compute/`** - Virtual machine resources. For test only in hub, move to spoke in production.

## Resource Details

### Networking (`modules/net/`)

- Hub VNet with subnets:
  - Default subnet (10.0.1.0/24)
  - Bastion subnet (10.0.12.0/26)
  - Application Gateway subnet (10.0.2.0/24)
- Network Security Groups (NSGs) with rules:
  - Allow SSH (port 22) from Bastion to Default Subnet

### Hub Services (`modules/hubserv/`)

Shared infrastructure services deployed once in the hub:

- **Ingress**: Application Gateway (WAF_v2)
  - Public IP
  - HTTP listener and basic routing
  - Web Application Firewall enabled
  - Backend pool for VMs
- **Remote Access**: Azure Bastion (Standard SKU)
  - Public IP
  - Secure RDP/SSH access without exposing VMs
- **Egress**: NAT Gateway
  - Public IP
  - Shared outbound internet connectivity
  - Associated with Default Subnet

### Monitoring (`modules/monitoring/`)

- Log Analytics Workspace (30-day retention)
- Network Watcher (Azure built-in)
  - VNet flow logs with Traffic Analytics
  - Storage Account for flow logs

### Compute (`modules/compute/`)

- Storage Account for Boot Diagnostics
- Azure Linux Virtual Machine
  - OS: Ubuntu 22.04 LTS
  - Size: Standard_DS1_v2
  - Network Interface for Compute VM
    - IP from Default Subnet
  - SSH Key Authentication

### IAM & Security

**Security warning: The SSH key pair is stored in plain text in Terraform State. Use for lab only.**

- Azure Key Vault
  - SSH private key (stored securely)
  - SSH public key (used for VM access)

## 🎯 Key Features

- ✅ **Modular Design** - Reusable Terraform modules
- ✅ **Hub-and-Spoke Ready** - Easy to add spoke VNets
- ✅ **Cost Optimized** - Shared services in hub (75% savings vs per-VNet)
- ✅ **Secure** - Bastion for access, NAT for egress, AppGW WAF for ingress
- ✅ **Observable** - Network flow logs and Traffic Analytics

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/Jihillestad/tflab-linux-public.git
cd tflab-linux
```

### 2. Configure Variables

Create a `terraform.tfvars` file using some CFA'ish naming convention and SemVer for environment versioning:

```hcl
prefix       = "myorg"
project_name = "linuxlab"
environment  = "hub"
env_version  = "0.0.1"
location     = "norwayeast"
username     = "azureuser"

```

### 3. Setup Terraform Backend (Recommended)

You can keep it simple running a local backend, but I highly recommend using
a **blob storage backend** to get in to the professional DevOps way of work.
In this example I use environment variables to pass the storage account key and
subscription ID to Terraform.

In production, you should use a Managed Identity or Service Principal with
least privilege access to the storage account. For increased safety and DevOps
best practises, use CI/CD pilelines and branch protection rules to manage
your Terraform code.

Please see my Blog Post for more info:
[Terraform State in Azure Storage Container](https://www.jannidar.com/blog/terraform-state-in-azure-storage)

If you already have a storage container for Terraform State, this is how I do
it for simple labs:

1. `az login`
2. Run these commands:

```bash
# Variables
RESOURCE_GROUP_NAME="THE_RG_CONTAINING_YOUR_TF_BACKEND"
STORAGE_ACCOUNT_NAME="YOUR_TF_BACKEND_STORAGE_ACCOUNT_NAME"
CONTAINER_NAME=tfstate # Or whatever

# Export credentials
export ARM_ACCESS_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)
export ARM_SUBSCRIPTION_ID="YOUR_SUBSCRIPTION_ID"
```

3. Create a backend file, f.ex **tflab-linux.tfbackend**

```hcl
storage_account_name = "YOUR_TF_BACKEND_STORAGE_ACCOUNT_NAME"
container_name = "tfstate" # Or whatever
key = "tflab-linux/terraform.tfstate"
```

### 4. Deploy Infrastructure

- Initialize Terraform: `terraform init -backend-config="tflab.linux.tfbackend"`

- Validate configuration: `terraform validate`

- Plan and verify before applying: `terraform plan`

- Deploy the infrastructure: `terraform apply`

## 🔄 Adding a Spoke VNet

**Important! The example below is not implemented in this repository. You are
welcome to use it as a starter for creating spokes in your own repository.
Create a folder and file structure like the examples below if you want to
dive deeper into hub-and-spoke topology.**

### Folder Structure

To add spokes, start by adding a folder named **./env** to contain your
environment-specific configurations. Each environment (dev, test, prod) should
have its own subfolder and their own terraform state backends. For example, to
create a development environment, create a folder structure like this:

```.
├── env
│   └── dev
│       ├── main.tf
│       ├── dev.tfbackend
│       ├── variables.tf
│       └── terraform.tfvars


```

### Example Spoke backend configuration (dev.tfbackend)

```hcl
storage_account_name = "YOUR_TF_BACKEND_STORAGE_ACCOUNT_NAME"
container_name       = "tfstate"
key                  = "tflab-linux/dev/terraform.tfstate"
```

### terraform.tfvars

```hcl
prefix       = "myorg"
project_name = "linuxlab"
environment  = "dev"
env_version  = "0.0.1"
location     = "norwayeast"
username     = "azureuser"
```

### variables.tf

```hcl
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "jih"
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "norwayeast"
  validation {
    condition     = contains(["norwayeast", "norwaywest", "westeurope", "northeurope"], var.location)
    error_message = "The location must be one of: norwayeast, norwaywest, westeurope, northeurope."
  }
}

variable "username" {
  description = "The admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "env_version" {
  description = "The version of the environment following semantic versioning (e.g., v1.0.0)"
  type        = string
  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.env_version))
    error_message = "The environment version must follow semantic versioning (e.g., v1.0.0)."
  }
}
```

### main.tf

```hcl
# Data sources to reference hub infrastructure
data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME"
    container_name       = "tfstate"
    key                  = "tflab-linux/terraform.tfstate"
  }
}

# Local variables
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Version     = var.env_version
  }

  # Dev spoke VNet configuration
  spoke_vnet = {
    name          = "${var.prefix}-${var.project_name}-vnet-${var.environment}"
    address_space = ["10.1.0.0/16"]
    subnets = {
      default = {
        name         = "default"
        cidr_newbits = 8
        cidr_netnum  = 1
        nsg_enabled  = true
      }
      aks = {
        name         = "aks"
        cidr_newbits = 8
        cidr_netnum  = 2
        nsg_enabled  = true
      }
    }
  }
}

resource "azurerm_resource_group" "dev_aks_spoke_rg" {
  name     = "${var.prefix}-${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}

# Spoke network (no hub services)
module "spoke_network" {
  source = "../../modules/net/"

  resource_group_name = azurerm_resource_group.dev_aks_spoke_rg.name
  location            = var.location
  vnet_config         = local.spoke_vnet
  tags                = local.common_tags
}

# VNet Peering: Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-dev"
  resource_group_name       = data.terraform_remote_state.hub.outputs.hub_rg_name
  virtual_network_name      = data.terraform_remote_state.hub.outputs.hub_vnet_name
  remote_virtual_network_id = module.spoke_network.vnet_id

  allow_forwarded_traffic = true
  allow_gateway_transit   = true
}

# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "dev-to-hub"
  resource_group_name       = azurerm_resource_group.dev_aks_spoke_rg.name
  virtual_network_name      = module.spoke_network.vnet_name
  remote_virtual_network_id = data.terraform_remote_state.hub.outputs.hub_vnet_id

  allow_forwarded_traffic = true
  use_remote_gateways     = false  # Set to true if hub has VPN Gateway
}


```

### Deploy Spoke

From within the `./env/dev` folder, run:

```bash
terraform init -backend-config="dev.tfbackend"
terraform validate
terraform plan
terraform apply
```

## 💰 Cost Considerations

### Hub Infrastructure (Always Running)

| Service            | Monthly Cost (Est.) | Notes                       |
| ------------------ | ------------------- | --------------------------- |
| Bastion Standard   | ~$140               | Shared across all spokes    |
| NAT Gateway        | ~$33                | Plus data egress charges    |
| App Gateway WAF_v2 | ~$240               | Minimum 2 instances for HA  |
| Log Analytics      | ~$50                | Depends on ingestion volume |
| Network Watcher    | ~$5                 | Flow logs storage extra     |
| **Hub Total**      | **~$470/month**     | Shared by all environments  |

### Per-Spoke Infrastructure

| Service         | Monthly Cost (Est.) | Notes                     |
| --------------- | ------------------- | ------------------------- |
| VNet            | Free                | No charge for VNet itself |
| VNet Peering    | ~$10                | Data transfer charges     |
| NSGs            | Free                | No charge                 |
| VMs             | Variable            | Depends on size and count |
| **Spoke Total** | **~$10/month**      | Plus VM costs             |

**Cost Optimization:**

- Spokes only pay for VNet peering + their own resources
- No duplication of Bastion, NAT, or AppGW ($413/spoke savings!)
- Auto-shutdown VMs in dev/test during off-hours

## 🧹 Cleanup

To avoid ongoing charges, destroy resources when not in use:

```bash
# Destroy hub infrastructure
terraform destroy

# If you created spokes, destroy them first:
cd env/dev
terraform destroy
cd ../..
terraform destroy  # Then destroy hub
```

## 📚 Additional Resources

- [Module Documentation](./modules/) - Detailed module READMEs
- [CHANGELOG.md](./CHANGELOG.md) - Version history
- [Terraform State in Azure Storage](https://www.jannidar.com/blog/terraform-state-in-azure-storage) - Backend setup guide
- [Azure Hub-Spoke Topology](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)

## Disclaimer

This code is provided "as is" and is intended for lab and educational purposes
only. It may not follow best practices for production environments. Use at your
own risk.

**Cost Warning:** Running this infrastructure incurs Azure charges (~$500-800/month for hub + multiple spokes). Remember to destroy resources when not in use.

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Suggestions and improvements welcome via issues or pull requests.

---

**Author:** Jann Idar Hillestad  
**Blog:** [www.jannidar.com](https://www.jannidar.com)  
**Project:** Learning Lab - Not for Production Use
