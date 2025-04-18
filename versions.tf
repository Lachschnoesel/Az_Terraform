terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
  backend "azurerm" {
    storage_account_name = "stbuq23adnj6"
    container_name       = "important"
    key                  = "keyvault"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "6024a9fe-ffe1-4b9d-abdc-3602ebb0a582"
}

