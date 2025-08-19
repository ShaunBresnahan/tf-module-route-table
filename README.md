# Terraform Module: for Azure vnet with nsg

## Required Resources

- `Resource Group` exists or is created external to the module.

## Usage

```terraform

variable "spokerg" {
  description = "Name of spoke resource group"
  type        = string
}

variable "id" {
  description = "Environment identifier (used in VNet naming convention)"
  type        = string
}

variable "routetable" {
  description = "Spoke route table name"
  type        = string
}

variable "spokeroute" {
  description = "List of spoke route names"
  type        = list(string)
}

variable "hop" {
  description = "List of next hop types (e.g. [\"VirtualNetworkGateway\"])"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Map of subnet IDs keyed by subnet name"
  type        = map(string)
}

variable "spokeprefix" {
  description = "List of route address prefixes (e.g. [\"10.0.0.0/16\"])"
  type        = list(string)
}

module "routetable" {
  source    = "./tf-module-route-table"
  providers = {
    azurerm.spoke = azurerm.something
  }
  spokerg      = var.spokerg
  id           = var.id
  routetable   = var.routetable
  spokeroute   = var.spokeroute
  hop          = var.hop
  subnet_ids   = module.spokesetup.subnet_ids
  spokeprefix  = var.spokeprefix
}
```