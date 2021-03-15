terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.51.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "azure-dev"

    workspaces {
      name = "tf_management"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
