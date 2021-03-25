provider "azurerm" {
  features {}
  subscription_id = local.subscription_id 
}

data "azurerm_resource_group" "main" {
    depends_on          = [azurerm_resource_group.rg] 
    name                = local.spokerg   
}

data "azurerm_subnet" "main" {
  depends_on = [module.spokesetup]   
  name = local.spokesubnet
  resource_group_name  = local.spokerg
  virtual_network_name = local.spokevnet 
}

data "azurerm_resource_group" "mainkv" {
    name = local.spokekv                 
}

data "azurerm_key_vault" "main" {
  name                = local.key_vault_name
  resource_group_name = data.azurerm_resource_group.mainkv.name
}

data "azurerm_key_vault_certificate" "main" {
  name         = local.certificate_name
  key_vault_id = data.azurerm_key_vault.main.id
}
locals {
  spokekv                        = "taskmanagerappgateway-RG"
  spokevnet                      = "Taskmanager-Pre-AG-vnet"
  spokesubnet                    = "Taskmanager-Pre-AG-subnet"
  spokerg                        = "m-taskmanager-pre-appgateway-RG"
  spokepip                       = "Taskmanager-Pre-AG-pip"
  backend_address_pool_name      = "taskmanager-pre-web-portal-beap"
  backend_address_pool_name_ncne = "taskmanager-pre-web-NCNEPortal-beap"
  backend_address_pool_name_dbupdate = "taskmanager-pre-web-dbupdate-beap"                                      
  frontend_port_name             = "taskmanager-pre-web-portal-feport" # change name to be more genric                                      
  frontend_ip_configuration_name = "taskmanager-pre-feip"                                       
  frontend_ip_configuration_namep= "taskmanager-pre-feip-private"                                 
  private_ip_address             = "10.240.217.10"
  http_setting_name_web          = "taskmanager-pre-web-portal-httpset"  #might not work
  http_setting_name_ncne         = "taskmanager-pre-web-NCNEPortal-httpset" 
  http_setting_name_dbupdate     = "taskmanager-pre-web-dbupdate-httpset"                                        
  listener_name                  = "taskmanager-pre-web-portal-listener"
  listener_name_ncne		         = "taskmanager-pre-web-NCNEPortal-listener"
  listener_name_dbupdate         = "taskmanager-pre-web-dbupdate"                                             
  request_routing_rule_name      = "taskmanager-pre-web-portal-rqrt"
  request_routing_rule_name_ncne = "taskmanager-pre-web-NCNEPortal-rqrt"
  request_routing_rule_name_dbupdate = "taskmanager-pre-web-dbupdate-rqrt"                                                                            
  gatewayname                    = "Taskmanager-Pre-appgateway"
  gatewayipconfigurationname     = "Taskmanager-Pre-gatewayip"
  subnet_name                    = "Taskmanager-Pre-PE-subnet"
  vnet_name                      = "Taskmanager-Pre-AG-vnet"
  key_vault_name                 = "taskmanagerappgateway-kv"
  gateway_certificate_name       = "Wildcard"
  certificate_name               = "Wildcard" 
  managedidentityname            = "mi-taskmanagerappgateway"
  web_probe_name                 = "taskmanager-pre-web-portal"
  web_probe_host                 = "taskmanager-pre-web-portal.azurewebsites.net"
  ncne_probe_name		             = "taskmanager-pre-web-NCNEPortal"
  ncne_probe_host		             = "taskmanager-pre-web-NCNEPortal.azurewebsites.net"
  dbupdate_probe_name		         = "taskmanager-pre-web-dbupdate"
  dbupdate_probe_host		         = "taskmanager-pre-web-dbupdate.azurewebsites.net"
  listener_host_name             = "taskmanager-pre-web-portal.engineering.ukho.gov.uk"
  listener_host_name_ncne	       = "taskmanager-pre-web-NCNEPortal.engineering.ukho.gov.uk"
  listener_host_name_dbupdate	   = "taskmanager-pre-web-dbupdate.engineering.ukho.gov.uk"
  rewrite_rule_set_web           = "taskmanager-pre-web-portal-rwset"
  rewrite_rule_web               = "taskmanager-pre-web-portal"
  pattern_web                    = "(.*)taskmanager-pre-web-portal.azurewebsites.net(.*)"
  header_value_web               = "{http_resp_Location_1}taskmanager-pre-web-portal.engineering.ukho.gov.uk{http_resp_Location_2}"
  rewrite_rule_set_ncne          = "taskmanager-pre-web-NCNEPortal-rwset"
  rewrite_rule_ncne              = "taskmanager-pre-web-NCNEPortal"
  pattern_ncne                   = "(.*)taskmanager-pre-web-NCNEPortal.azurewebsites.net(.*)"
  header_value_ncne              = "{http_resp_Location_1}taskmanager-pre-web-NCNEPortal.engineering.ukho.gov.uk{http_resp_Location_2}"
}

data "azurerm_subscription" "current" {
}

resource "azurerm_user_assigned_identity" "gateway_managed_identity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.managedidentityname
  lifecycle { ignore_changes = [tags] }  
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = data.azurerm_key_vault.main.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_user_assigned_identity.gateway_managed_identity.principal_id

  certificate_permissions = [
    "get"
  ]

  key_permissions = [
    "get"
  ]

  secret_permissions = [
    "get"
  ]
}

resource "azurerm_public_ip" "main" {
  depends_on          = [azurerm_resource_group.rg]
  provider            = azurerm.tm2ag
  sku                 = "Standard"
  name                = local.spokepip
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  lifecycle { ignore_changes = [tags] }    
}
#
resource "azurerm_application_gateway" "main" {
  depends_on          = [module.spokesetup]  
  provider            = azurerm.tm2ag
  name                = local.gatewayname
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  lifecycle { ignore_changes = [tags] } #request_routing_rule
 
  
  autoscale_configuration {	 
    min_capacity = 1	 
    max_capacity = 4	 
  }
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  gateway_ip_configuration {
    name      = local.gatewayipconfigurationname
    subnet_id = data.azurerm_subnet.main.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  frontend_ip_configuration {
    name                          =  local.frontend_ip_configuration_namep
    subnet_id                     =  data.azurerm_subnet.main.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.private_ip_address
  }

  backend_address_pool {
    name = local.backend_address_pool_name #ip_addresses = [ "value" ] # This is the PE ip which will probably need manually adding at the end #fqdns = [ "value" ] # either i guess                                                                                                             
  }

  probe {
    name                = local.web_probe_name 
    host                = local.web_probe_host
    interval            = 30
    protocol            = "https"
    path                = "/health"
    timeout             = 30
    unhealthy_threshold = 3  
  }

  backend_http_settings {
    name                  = local.http_setting_name_web
    cookie_based_affinity = "Disabled"
    path                  = "/health"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20
    probe_name            = local.web_probe_name 
    host_name             = local.web_probe_host  
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name_web  
 } 

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_namep # Add the 1 associated listener bit and re-run as we need this against private not public
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    host_name                      = local.listener_host_name # adds host name 
    ssl_certificate_name           = local.gateway_certificate_name     #certificate_name
  }
#################################################################################################################

 backend_address_pool {
   name = local.backend_address_pool_name_ncne
  }
 probe {
   name                = local.ncne_probe_name                      
   host                = local.ncne_probe_host                      
   interval            = 30
   protocol            = "https"
   path                = "/health"
   timeout             = 30
   unhealthy_threshold = 3  
  }
  
  backend_http_settings {
    name                  = local.http_setting_name_ncne
    cookie_based_affinity = "Disabled"
    path                  = "/health"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20
    probe_name            = local.ncne_probe_name 
    host_name             = local.ncne_probe_host  
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_ncne
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_ncne
    backend_address_pool_name  = local.backend_address_pool_name_ncne
    backend_http_settings_name = local.http_setting_name_ncne  
 } 

  http_listener {
    name                           = local.listener_name_ncne
    frontend_ip_configuration_name = local.frontend_ip_configuration_namep # Add the 1 associated listener bit and re-run as we need this against private not public
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    host_name                      = local.listener_host_name_ncne # adds host name 
    ssl_certificate_name           = local.gateway_certificate_name     #certificate_name
  }


  
  
  ssl_certificate {
    name                = local.gateway_certificate_name
    key_vault_secret_id = data.azurerm_key_vault_certificate.main.secret_id     
  }


  identity {
    identity_ids = [azurerm_user_assigned_identity.gateway_managed_identity.id]
  }
     

  rewrite_rule_set {
    name          = local.rewrite_rule_set_web

  rewrite_rule {
    name          = local.rewrite_rule_web
    rule_sequence = 100  
    
  condition {
    variable = "http_req_Location"
    pattern = local.pattern_web
}
  response_header_configuration {
    header_name = "Location"
    header_value = local.header_value_web 
   }
  }
 }

  rewrite_rule_set {
    name          = local.rewrite_rule_set_ncne

  rewrite_rule {
    name          = local.rewrite_rule_ncne
    rule_sequence = 100  
    
  condition {
    variable = "http_req_Location"
    pattern = local.pattern_ncne
}
  response_header_configuration {
    header_name = "Location"
    header_value = local.header_value_ncne 
   }
  }
 }




}




###########################DBUPDATE######################



#  backend_address_pool {
  #  name = local.backend_address_pool_name_dbupdate
  #}
#
  #probe {
  #  name                = local.dbupdate_probe_name                   
  #  host                = local.dbupdate_probe_host                  
  #  interval            = 30
  #  protocol            = "https"
  #  path                = "/health"
  #  timeout             = 30
  #  unhealthy_threshold = 3  
  #}


  #backend_http_settings {
  #  name                  = local.http_setting_name_dbupdate
  #  cookie_based_affinity = "Disabled"
  #  path                  = "/health"
  #  port                  = 443
  #  protocol              = "Https"
  #  request_timeout       = 20
  #  probe_name            = local.dbupdate_probe_name 
  #  host_name             = local.dbupdate_probe_host  
  #}

  #request_routing_rule {
 #  name                       = local.request_routing_rule_name_dbupdate
 #  rule_type                  = "Basic"
 #  http_listener_name         = local.listener_name_dbupdate
 #  backend_address_pool_name  = local.backend_address_pool_name_dbupdate
 #  backend_http_settings_name = local.http_setting_name_dbupdate  
 # }



  #http_listener {
  #  name                           = local.listener_name_dbupdate
  #  frontend_ip_configuration_name = local.frontend_ip_configuration_name1 # Add the 1 associated listener bit and re-run as we need this against private not public
  #  frontend_port_name             = local.local.frontend_port_name
  #  protocol                       = "Https"
  #  host_name                      = local.listener_host_name_dbupdate # adds host name 
  #  ssl_certificate_name           = local.gateway_certificate_name     #certificate_name
  #}