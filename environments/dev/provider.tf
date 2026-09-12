terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0, < 5.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-backend"
    storage_account_name = "aibasedtodo"
    container_name       = "tfstate"
    key                  = "axion.dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
