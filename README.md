# Route Tables


module "create" {
  source = "github.com/UKHO/tfmodule-azure-routetable-hub-spoke?ref=0.4.1"
  providers = {
        azurerm.hub   = azurerm.hub
        azurerm.spoke = azurerm.ALIAS
        
}
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
