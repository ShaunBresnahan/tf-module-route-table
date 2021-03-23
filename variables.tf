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