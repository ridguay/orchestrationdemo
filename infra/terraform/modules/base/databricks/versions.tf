terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.15.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
  }

}
