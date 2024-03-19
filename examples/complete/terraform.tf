terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      # pinned because of
      # https://github.com/hashicorp/terraform-provider-azurerm/issues/25291
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}
