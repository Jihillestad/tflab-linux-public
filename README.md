# tflab-linux

This repository contains a simplified single Resouce Group Azure Landing Zone (LZ) setup intented for learning and experimentation purposes. It is not designed for production use.

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.5 installed
- Storage Account for Terraform backend (optional, but recommended)

## Resource Details

### Networking

#### Version 0.1.1-2

- Vnet with subnets:
  - Default subnet
  - Bastion subnet
  - Public IP for Bastion
- Network Security Groups (NSGs) with basic rules:
  - Allow SSH (port 22) inbound (Keeping it simple for lab usage)

### Monitoring

- Log Analytics Workspace
- Network Watcher
  - Virtual Network flow logs enabled
- Storage Account for flow logs

### Compute

#### Version 0.1.1-2

This release is for showing how to set up a basic Linux VM in Azure. The
Terraform code creates the necessary Azure boilerplate needed for a VM, and
some basic LZ stuff.

- Public IP for Compute VM
- Network Interface for Compute VM
  - IP from Default Subnet
  - Public IP for Compute CM

#### Future versions

The functionality will depend on what I am currently learning and sharing

### IAM

- Azure Key Vault
- SSH keys:
  - Private key
  - Public Key

## Variable Example (.tfvars)

Using some CFA'ish naming convention and SemVer for environment versioning:

```hcl
prefix       = "myorg"
project_name = "linuxlab"
environment  = "core"
env_version  = "0.0.1"
```

## How to use

### Terraform Backend

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

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_SUBSRIPTION_ID=YOUR_SUBSCRIPTION_ID
```

3. Create a backend file, f.ex **tflab-linux.tfbackend**

```hcl
storage_account_name = "YOUR_TF_BACKEND_STORAGE_ACCOUNT_NAME"
container_name = "tfstate" # Or whatever
key="tflab-linux/terraform.tfstate"
```

4. Initialize Terraform: `terraform init -backend-config="tflab.linux.tfbackend"`

5. `terraform plan`

6. `terraform apply`

### Disclaimer

This code is provided "as is" and is intended for lab and educational purposes
only. It may not follow best practices for production environments. Use at your
own risk.
