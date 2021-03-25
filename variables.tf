
variable "ProjectIdentity" {
  default = "Taskmanager-Pre-AG"
}

variable "MAIN_LOCATION" {
  type    = string
  default = "uksouth"
}

variable "MAIN_ADDRESS" {
  default = "10.240.217.0/24"
}

variable "DNS_SERVERS" {
  default = [
    "10.240.253.133",
    "10.240.253.132",
  ]
}

variable "SUBNETS" {
  default = [
    {
      name   = "Taskmanager-Pre-AG-subnet"
      number = 0 
    },
    {
      name   = "Taskmanager-Pre-PE-subnet"
      number = 1 
    }
  ]
}

variable "NEWBITS" {
  default = 4
}

#variable "certificate_name" {
#  default = "Wildcard_WITHKEY"
#}


variable "MAIN_ENDPOINTS" {
  default = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "TAGS" {
  type = map
  default = {
    ENVIRONMENT      = "Pre",
    SERVICE          = "Taskmanager",
    SERVICE_OWNER    = "Thomas Scott-Clarke",
    RESPONSIBLE_TEAM = "Tamatoa",
    CALLOUT_TEAM     = "On-Call_N/A"
  }
}

variable "spokerg" {
  default = "m-taskmanager-pre-appgateway-RG"
}
variable "hubrg" {
  default = "engineering-rg"
}
variable "hubrt" {
  default = "EngineeringAD-RT"
}
variable "id" {
  default = "Taskmanager-Pre-AG"
}
variable "routetable" {
  default = "Taskmanager-Pre-AG-rt" 
}
variable "spokeroute" {
  default = ["to-M-EngineeringAD-route" , "to-M-Laptops-route"]
}
variable "hubroute" {
  default = ["to-M-Taskmanager-Pre-AG-route"] 
}
variable "hop" {
  default = ["VirtualNetworkGateway" , "VirtualNetworkGateway"]
}
variable "subnets" {
  default = "Taskmanager-Pre-AG-subnet"
}
variable "hubprefix" {
  default = ["10.240.217.0/24"]
}
variable "spokeprefix" {
  default = ["10.240.253.128/25" , "10.98.0.0/22"]
}
