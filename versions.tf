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
    resource_group_name  = "rg-danisTest-dev"
    storage_account_name = "stnkloksazzb"
    container_name       = "important"
    key                  = "backend-state-file"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "6024a9fe-ffe1-4b9d-abdc-3602ebb0a582"
}

