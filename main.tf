resource "azapi_resource" "rg01" {
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "rg-${var.application_name}-${var.application_name}"
  location  = var.primary_region
  parent_id = "/subscriptions/${data.azapi_client_config.current_User.subscription_id}"
}

data "azapi_client_config" "current_User" {}

resource "azapi_resource" "vmpip" {
  type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
  name      = "pip${var.application_name}${var.instituion_name}"
  location  = azapi_resource.rg01.location
  parent_id = azapi_resource.rg01.id

  body = {
    properties = {
      publicIPAllocationMethod = "Static"
      publicIPAddressVersion   = "IPv4"
    }
    sku = {
      name = "Standard"
    }
  }
}

data "azapi_resource" "network_rg" {
  name      = "rg-network-dev"
  parent_id = "/subscripions/${data.azapi_client_config.current_User.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
}

data "azapi_resource" "vnet" {
  name      = "vnet-network-dev"
  parent_id = data.azapi_resource.network_rg.id
  type      = "Microsoft.Network/virtualNetworks@2024-05-01"
}

data "azapi_resource" "vm_subnet" {
  name      = "subnetsecond"
  parent_id = data.azapi_resource.network_rg.id
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"

  response_export_values = ["names"]
}

resource "azapi_resource" "vm1_nic" {
  type      = "Microsoft.AzureStackHCI/networkInterfaces@2025-04-01-preview"
  name      = "nic-${var.application_name}-${var.instituion_name}"
  location  = data.azapi_resource.network_rg.location
  parent_id = azapi_resource.rg01

  body = {
    properties = {
      ipConfigurations = [
        {
          name = "public"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddresses = {
              id = azapi_resource.vmpip.id
            }
            subnet = {
              id = data.azapi_resource.vm_subnet.id
            }
          }
        }
      ]
    }
  }
}
