locals {
  vnet_name = "${var.id}-vnet"
}

data "azurerm_resource_group" "main" {
  provider = azurerm.spoke
  name     = var.spokerg
}

resource "azurerm_route_table" "main" {
  provider            = azurerm.spoke
  name                = var.routetable
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_route_table_association" "main" {
  for_each       = var.subnet_ids
  provider       = azurerm.spoke
  subnet_id      = each.value
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_route" "main" {
  for_each = {
    for idx, route_name in var.spokeroute : route_name => {
      name           = route_name
      address_prefix = var.spokeprefix[idx]
      next_hop_type  = var.hop[idx]
    }
  }

  provider            = azurerm.spoke
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.main.name
  route_table_name    = azurerm_route_table.main.name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
}



############## OLD ###############


#locals {
#  vnet_name = "${var.id}-vnet"
#}
#
## Spoke RG
#data "azurerm_resource_group" "main" {
#  provider = azurerm.spoke
#  name     = var.spokerg
#}
#
## Spoke route table
#resource "azurerm_route_table" "main" {
#  provider            = azurerm.spoke
#  name                = var.routetable
#  location            = data.azurerm_resource_group.main.location
#  resource_group_name = data.azurerm_resource_group.main.name
#
#  lifecycle {
#    ignore_changes = [tags]
#  }
#}
#
## Associate subnets to spoke route table (IDs passed in from subnet module)
#resource "azurerm_subnet_route_table_association" "main" {
#  for_each       = var.subnet_ids
#  provider       = azurerm.spoke
#  subnet_id      = each.value
#  route_table_id = azurerm_route_table.main.id
#}
#
## Hub RG
#data "azurerm_resource_group" "hub" {
#  provider = azurerm.hub
#  name     = var.hubrg
#}
#
## Hub route table
#data "azurerm_route_table" "hub" {
#  provider            = azurerm.hub
#  name                = var.hubrt
#  resource_group_name = data.azurerm_resource_group.hub.name
#}
#
## Spoke routes
#resource "azurerm_route" "spoke" {
#  for_each = {
#    for idx, route_name in var.spokeroute : route_name => {
#      name           = route_name
#      address_prefix = var.spokeprefix[idx]
#      next_hop_type  = var.hop[idx]
#    }
#  }
#
#  provider            = azurerm.spoke
#  name                = each.value.name
#  resource_group_name = data.azurerm_resource_group.main.name
#  route_table_name    = azurerm_route_table.main.name
#  address_prefix      = each.value.address_prefix
#  next_hop_type       = each.value.next_hop_type
#}
#
## Hub routes
#resource "azurerm_route" "hub" {
#  for_each = {
#    for idx, route_name in var.hubroute : route_name => {
#      name           = route_name
#      address_prefix = var.hubprefix[idx]
#      next_hop_type  = var.hop[idx]
#    }
#  }
#
#  provider            = azurerm.hub
#  name                = each.value.name
#  resource_group_name = data.azurerm_resource_group.hub.name
#  route_table_name    = data.azurerm_route_table.hub.name
#  address_prefix      = each.value.address_prefix
#  next_hop_type       = each.value.next_hop_type
#}
