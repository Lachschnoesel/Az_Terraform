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

resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
data "azapi_resource" "devops-rg" {
  name      = "rg-devops-dev"
  parent_id = "/subscriptions/${data.azapi_client_config.current_User.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
}

data "azapi_resource" "keyvautl" {
  name      = "kv-devops-dev-222921"
  parent_id = data.azapi_resource.network_rg.id
  type      = "Microsoft.KeyVault/vault@2024-12-01-preview"
}


resource "azapi_resource" "ssh-vm-secret" {
  type                      = "Microsoft.KeyVault/vaults/secrets@2024-12-01-preview"
  name                      = "azapivm-ssh-private"
  parent_id                 = data.azapi_resource.keyvautl.id
  schema_validation_enabled = false
  body = {
    properties = {
    }
    value = tls_private_key.vm1.private_key_pem
  }
  lifecycle {
    ignore_changes = [location]
  }
}

resource "azapi_resource" "ssh-vm-public" {
  type                      = "Microsoft.KeyVault/vaults/secrets@2024-12-01-preview"
  name                      = "azapivm-ssh-public"
  parent_id                 = data.azapi_resource.keyvautl.id
  schema_validation_enabled = false

  body = {
    properties = {
    }
    value = tls_private_key.vm1.public_key_openssh
  }
  lifecycle {
    ignore_changes = [location]
  }

}

resource "azapi_resource" "symbolicname" {
  type      = "Microsoft.Compute/virtualMachines@2024-11-01"
  name      = "vm1${var.application_name}${var.instituion_name}"
  location  = azapi_resource.rg01.location
  parent_id = azapi_resource.rg01.id

  body = {
    properties = {
      networkProfile = {
        hardwareProfile = {
          vmSize = "Standard_D2_v2_Promo"
        }
        networkInterfaces = [
          {
            id = azapi_resource.vm1_nic.id
          }
        ]
      }
      osProfile = {
        adminusername = "adminuser"
        computername  = "vm1${var.application_name}${var.instituion_name}"
        linuxConfiguation = {
          ssh = {
            publicKeys = [
              {
                keydata = tls_private_key.vm1.public_key_openssh
                path    = "/home/adminuser/.ssh/authorzed_keys"
              }

            ]
          }
        }

      }
      storageProfile = {
        imageReference = {
          offer     = "Canonical"
          publisher = "0001-com-ubunto-server-jammy"
          sku       = "22-04-lts"
          version   = "latest"

        }
        osDisk = {
          caching      = "ReadWrite"
          createOption = "FromImage"
          managedDisk = {
            storageAccountType = "Standard_LRS"
          }
        }

      }

    }

  }
}
