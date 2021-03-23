# Terraform Module: for Azure route table with multiple routes

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

```terraform
# Route Tables Additional Routes

## Creating multiple routes under the spoke and hub tables

## Usage Vars

variable "spokerg" {
 #description = "name of spoke resource group"
}
variable "hubrg" {
 #description = "name of hub resource group"
}
variable "hubrt" {
  #description = "hub route table name" 
}
variable "id" {
  #description = "environment you're deploying too"
}
variable "routetable" {
  #description = "spoke route table"
}
variable "spokeroute" {
  #description = "Spoke routetable route array [""]
}
variable "hubroute" {
  #description = "Hub routetable routes" [""]
}
variable "hop" {
  #description = "The type of hop you require in a array" ["VirtualNetworkGateway"]
}
variable "subnets" {
 #description = "array contains names of subnets, the subnet array used on the tfmodule-azure-vnet-with-nsg fits this expected pattern" 
}
variable "spokeprefix" {
  #description = "Spoke ip route array" [""]
}
variable "hubprefix" {
  #description = "hub ip route array" [""]  
}

## Module

module "create" {
    source                    = "github.com/UKHO/route-table-additional-routes"
    providers = {
        azurerm.hub   = azurerm.hub
        azurerm.spoke = azurerm.test
    }    
    spokerg                 =  var.spokerg
    hubrg                   =  var.hubrg
    hubrt                   =  var.hubrt
    id                      =  var.id
    routetable              =  var.routetable
    spokeroute              =  var.spokeroute
    hubroute                =  var.hubroute
    hop                     =  var.hop
    subnets                 =  var.SUBNETS
    hubprefix               =  var.hubprefix
    spokeprefix             =  var.spokeprefix
}
