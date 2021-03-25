locals {
  subscription_id     = "5739fe4c-408e-45ba-941e-301ae4525146"
  hub_subscription_id = "282900b8-5415-4137-afcc-fd13fe9a64a7"
}

provider "azurerm" {
  features {}
  alias = "tm2ag"
  subscription_id = local.subscription_id
  
}

provider "azurerm" {
  features {}
  alias = "hub"
  subscription_id = local.hub_subscription_id
}

terraform {
  backend "azurerm" {
    resource_group_name  = "DigitalOpsDev-RG"
    storage_account_name = "digitalopsdevstorage"
    container_name       = "tfstate"
    key                  = "tm2preag.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  provider = azurerm.tm2ag
  name     = "m-taskmanager-pre-appgateway-RG"
  location = "UKSouth"
  lifecycle { ignore_changes = [tags] }
}

module "spokesetup" {
  source                      = "github.com/ukho/tfmodule-azure-vnet-with-nsg?ref=0.4.0"
  providers = {
    azurerm.src = azurerm.tm2ag
  }
  depends_on                  = [azurerm_resource_group.rg]
  resource_group              = azurerm_resource_group.rg
  tags                        = var.TAGS
  prefix                      = var.ProjectIdentity
  address                     = var.MAIN_ADDRESS
  dns_servers                 = var.DNS_SERVERS
  subnets                     = var.SUBNETS
  newbits                     = var.NEWBITS
  service_endpoints           = var.MAIN_ENDPOINTS
}

resource "azurerm_network_security_rule" "tmnsb1" {
  provider                    = azurerm.tm2ag
  name                        = "web-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985"
  source_address_prefix       = "62.172.108.6"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = module.spokesetup.network_security_group_name
}

resource "azurerm_network_security_rule" "tmnsb2" {
  provider                    = azurerm.tm2ag
  name                        = "sec-rule"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "62.172.108.6"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = module.spokesetup.network_security_group_name
}
resource "azurerm_network_security_rule" "tmnsb3" {
  provider                    = azurerm.tm2ag
  name                        = "FromEngineeringsIaaS"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.240.253.128/25"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = module.spokesetup.network_security_group_name
}

resource "azurerm_network_security_rule" "tmsb4" {
  provider                    = azurerm.tm2ag
  name                        = "Appgateway"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = module.spokesetup.network_security_group_name
}

module "peering" {
  source                      = "github.com/ukho/tfmodule-azure-vnet-peering-hub-to-spoke?ref=0.2.0"
  providers = {
        azurerm.hub   = azurerm.hub
        azurerm.spoke = azurerm.tm2ag
}
  depends_on                  = [module.spokesetup] 
  hubrg                       = "UKHO-VPN-RG"
  spokerg                     =  azurerm_resource_group.rg.name
  hubvnet                     = "UKHO-VPN-vnet"
  spokevnet                   = "${var.ProjectIdentity}-vnet"
  peer1to2                    = "peering-UKHO-VPN-vnet-to-${var.ProjectIdentity}-vnet"
  peer2to1                    = "peering-${var.ProjectIdentity}-vnet-to-UKHO-VPN-vnet"
}

module "create" {
  source = "github.com/UKHO/tfmodule-azure-routetable-hub-spoke?ref=0.4.1"
  providers = {
        azurerm.hub   = azurerm.hub
        azurerm.spoke = azurerm.tm2ag
        
}
  depends_on                  = [module.spokesetup]
  spokerg                     =  var.spokerg
  hubrg                       =  var.hubrg
  hubrt                       =  var.hubrt
  id                          =  var.id
  routetable                  =  var.routetable
  spokeroute                  =  var.spokeroute
  hubroute                    =  var.hubroute
  hop                         =  var.hop
  subnets                     =  var.SUBNETS
  hubprefix                   =  var.hubprefix
  spokeprefix                 =  var.spokeprefix  
}