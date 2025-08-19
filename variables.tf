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

# You can keep this if used elsewhere, but it's no longer needed for associations
variable "subnets" {
  description = "List of subnet names to associate with the route table"
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





### working #####


#variable "spokerg" {
#  description = "Name of spoke resource group"
#  type        = string
#}
#
#variable "id" {
#  description = "Environment identifier (used in VNet naming convention)"
#  type        = string
#}
#
#variable "routetable" {
#  description = "Spoke route table name"
#  type        = string
#}
#
#variable "spokeroute" {
#  description = "List of spoke route names"
#  type        = list(string)
#}
#
#variable "hop" {
#  description = "List of next hop types (e.g. [\"VirtualNetworkGateway\"])"
#  type        = list(string)
#}
#
#variable "subnets" {
#  description = "List of subnet names to associate with the route table"
#  type        = list(string)
#}
#
#variable "subnet_ids" {
#  description = "Map of subnet IDs keyed by subnet name"
#  type        = map(string)
#}
#
#variable "spokeprefix" {
#  description = "List of route address prefixes (e.g. [\"10.0.0.0/16\"])"
#  type        = list(string)
#}




#variable "spokerg" {
# #description = "name of spoke resource group"
#}
#variable "hubrg" {
# #description = "name of hub resource group"
#}
#variable "hubrt" {
#  #description = "hub route table name" 
#}
#variable "id" {
#  #description = "environment you're deploying too"
#}
#variable "routetable" {
#  #description = "spoke route table"
#}
#variable "spokeroute" {
#  #description = "Spoke routetable route array [""]
#}
#variable "hubroute" {
#  #description = "Hub routetable routes" [""]
#}
#variable "hop" {
#  #description = "The type of hop you require in a array" ["VirtualNetworkGateway"]
#}
#variable "subnets" {
# #description = "array contains names of subnets, the subnet array used on the tfmodule-azure-vnet-with-nsg fits this expected pattern" 
#}
#variable "spokeprefix" {
#  #description = "Spoke ip route array" [""]
#}
#variable "hubprefix" {
#  #description = "hub ip route array" [""]  
#}


