terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.44.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.7.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.1"
    }
  }
}
