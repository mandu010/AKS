
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "manduterraformrg"
      storage_account_name = "terraformstorageaccn007"
      container_name       = "terraformcontainer"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
   subscription_id      = "896c718b-3691-41d7-81ed-6587d464a0c9"
    client_id            = var.spn-client-id     // This is the application id
    client_secret        = var.spn-client-secret // Secret Value
    tenant_id            = var.spn-tenant-id
    features {}
}
