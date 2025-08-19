terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      configuration_aliases = [
        azurerm.spoke
      ]
    }
  }
}

#terraform {
#  required_providers {
#    azurerm = {
#      source = "hashicorp/azurerm"
#      configuration_aliases = [
#        azurerm.hub,
#        azurerm.spoke,
#      ]
#    }
#  }
#}

