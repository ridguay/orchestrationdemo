terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.51.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
      configuration_aliases = [
        azurerm
      ]
    }

  }


}
