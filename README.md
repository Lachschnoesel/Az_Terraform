# Terraform Azure Infrastructure Hands-on

This is a small project showcasing the use of Terraform with common Azure-related providers. It demonstrates infrastructure provisioning through both Terraform (`azurerm`, `azureAD`) and `az CLI`.

## 📦 Providers Used

- **azurerm**
- **azureAD**
- **az CLI**

## ☁️ Resources Created (via `azurerm` and `azureAD`)

1. **Resource Group**  
   - A storage account is created inside, containing a container for storing `.tfstate` files (remote backend).

2. **Monitoring Setup**  
   - A **Log Analytics Workspace** is provisioned for monitoring capabilities.

3. **Networking**  
   - A **Virtual Network (/22)** is created, with subnets derived using `cidrsubnet` operations from a base IP prefix defined in `variables.tf`.
   - A **Public IP (PIP)** is assigned and connected to a **Network Interface Card (NIC)** in the second subnet.

4. **Security and Access**  
   - **Azure Bastion** is used for secure access to VMs over the internet.
   - Secrets required by Bastion are stored securely in **Azure Key Vault**.
   - A **VM extension** is installed to enable Entra ID login (formerly Azure AD).  
     Requires:
     - Managed Identity  
     - Role-Based Access Control (RBAC)

## 🔁 Resources Created (via `az CLI`)

After initial setup with Terraform, certain VM components were recreated using `az CLI`.

**Why `az CLI`?**  
It provides **Day Zero support** for new Azure resources by translating commands directly into ARM templates, unlike `azurerm`, which has to be decoded in steps to be deployed via REST api.

## 🧠 Lessons Learned

- ✅ Always script your Terraform workflows.
- ✅ Automate all deployments for consistency across environments.
- ✅ Use variables to drive naming conventions and distinguish environments.
- ✅ Clean up unnecessary provider binaries after deployment — they consume a lot of disk space!
- ✅ **Terraform Workspaces** are powerful for deploying similar infrastructure across different environments.
- ✅ Use **outputs** generously for debugging and chaining Terraform with CLI or scripts.
