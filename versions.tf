terraform {
  required_providers {
    azureapi = {
      source  = "azure/azureapi"
      version = "~> 2.3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azureapi" {
}

