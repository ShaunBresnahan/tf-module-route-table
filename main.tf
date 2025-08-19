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

  # Optional safeguard to avoid churn unless the subnet ID changes
  lifecycle {
    replace_triggered_by = [each.value]
  }
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










### working ###


#locals {
#  vnet_name = "${var.id}-vnet"
#}
#
#data "azurerm_resource_group" "main" {
#  provider = azurerm.spoke
#  name     = var.spokerg
#}
#
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
#data "azurerm_subnet" "main" {
#  for_each            = toset(var.subnets)
#  provider            = azurerm.spoke
#  name                = each.value
#  resource_group_name = var.spokerg
#  virtual_network_name = local.vnet_name
#}
#
#resource "azurerm_subnet_route_table_association" "main" {
#  for_each       = data.azurerm_subnet.main
#  provider       = azurerm.spoke
#  subnet_id      = each.value.id
#  route_table_id = azurerm_route_table.main.id
#}
#
#resource "azurerm_route" "main" {
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



############## OLD ###############




#locals {
#  vnet_name = "${var.id}-vnet"
#}
#
#data "azurerm_resource_group" "main" {
#  provider = azurerm.spoke
#  name     = var.spokerg 
#}
#
#resource "azurerm_route_table" "main" {
#  provider                      = azurerm.spoke
#  name                          = var.routetable
#  location                      = data.azurerm_resource_group.main.location
#  resource_group_name           = data.azurerm_resource_group.main.name
#  
#  
#  lifecycle { ignore_changes = [tags] }
#}
#
#data "azurerm_subnet" "main" {
#  count                = length(var.subnets)
#  provider             = azurerm.spoke
#  name                 = var.subnets[count.index].name
#  resource_group_name  = var.spokerg
#  virtual_network_name = local.vnet_name
#}
#
#resource "azurerm_subnet_route_table_association" "main" {
#  count          = length(var.subnets)
#  provider       = azurerm.spoke
#  subnet_id      = data.azurerm_subnet.main[count.index].id
#  route_table_id = azurerm_route_table.main.id
#}
#
#data "azurerm_resource_group" "hub" {
#  provider = azurerm.hub
#  name     = var.hubrg
#}
#
#data "azurerm_route_table" "main" {
#  provider            = azurerm.hub
#  name                = var.hubrt
#  resource_group_name = data.azurerm_resource_group.hub.name
#}
#
#resource "azurerm_route" "main" {
#  provider            = azurerm.spoke
#  name                = var.spokeroute[count.index]
#  resource_group_name = data.azurerm_resource_group.main.name
#  route_table_name    = azurerm_route_table.main.name
#  address_prefix      = var.spokeprefix[count.index]
#  next_hop_type       = var.hop[count.index]
#  count               = length(var.spokeroute)
#}
#
#resource "azurerm_route" "main1" {
#  provider            = azurerm.hub
#  name                = var.hubroute[count.index]
#  resource_group_name = data.azurerm_resource_group.hub.name
#  route_table_name    = data.azurerm_route_table.main.name
#  address_prefix      = var.hubprefix[count.index]
#  next_hop_type       = var.hop[count.index]
#  count               = length(var.hubroute)
#}
#